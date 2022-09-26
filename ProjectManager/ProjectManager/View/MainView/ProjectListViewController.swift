//
//  ProjectListViewController.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/17.
//

import UIKit

final class ProjectListViewController: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    enum Schedule {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Schedule, ProjectUnit>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, ProjectUnit>

    private var dataSource: DataSource?
    private var snapshot: Snapshot?
    let viewModel: CommonViewModelLogic
    let controller: HistoryPopoverController

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.sectionHeaderHeight = 50

        return tableView
    }()

    init(viewModel: CommonViewModelLogic, controller: HistoryPopoverController) {
        self.viewModel = viewModel
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureDataSource()
        configureObserver()
        configureTapGesture()
        configureLongPressGesture()
        showAlert()
    }

    @objc private func didTapCell(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == UIGestureRecognizer.State.ended else {
            return
        }

        let tapLocation = recognizer.location(in: self.tableView)

        guard let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) else {
            return
        }

        presentModalEditView(indexPath: tapIndexPath.row)
    }

    @objc private func didPressCell(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == UIGestureRecognizer.State.ended else {
            return
        }

        let longPressLocation = recognizer.location(in: self.tableView)

        guard let tapIndexPath = self.tableView.indexPathForRow(at: longPressLocation),
              let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? ProjectManagerListCell else {
            return
        }

        configurePopoverController(indexPath: tapIndexPath.row, in: tappedCell)
    }

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        tableView.register(cellType: ProjectManagerListCell.self)
        tableView.delegate = self

        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: ProjectManagerListCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setContents(
                    title: item.title,
                    body: item.body,
                    date: item.deadLine.localizedString
                )

                if item.isDeadlinePassed {
                    cell.changeTextColor()
                }

                cell.separatorInset = .zero

                return cell
            }
        )
    }

    private func configureObserver() {
        viewModel.data.subscribe { [weak self] projectUnitArray in
            guard let self = self else {
                return
            }

            self.snapshot = self.configureSnapshot(data: projectUnitArray)

            guard let snapshot = self.snapshot else {
                return
            }

            self.dataSource?.apply(snapshot)
            self.tableView.reloadData()
        }

        viewModel.registerMovingHistory = { [weak self] (title, previous, next) in
            self?.controller.snapshot = self?.controller.configureSnapshot(data: [ProjectHistoryUnit(
                content: "Moved '\(title)' from \(previous) to \(next).",
                time: Date())]
            )

            guard let snapshot = self?.controller.snapshot else {
                return
            }

            self?.controller.dataSource?.apply(snapshot)
            self?.controller.tableView.reloadData()
        }

        guard var viewModel = self.viewModel as? ContentAddible else {
            return
        }

        viewModel.registerAdditionHistory = { [weak self] (title) in
            self?.controller.snapshot = self?.controller.configureSnapshot(data: [ProjectHistoryUnit(
                content: "Added '\(title)'.",
                time: Date())]
            )

            guard let snapshot = self?.controller.snapshot else {
                return
            }

            self?.controller.dataSource?.apply(snapshot)
            self?.controller.tableView.reloadData()
        }
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapCell(_:))
        )
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
    }

    private func configureLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didPressCell(_:))
        )
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    private func showAlert() {
        viewModel.showAlert = { [weak self] in
            guard let self = self else {
                return
            }

            let alert = UIAlertController(title: "Error", message: self.viewModel.message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)

            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }

    private func configureSnapshot(data: [ProjectUnit]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)

        return snapshot
    }

    private func presentModalEditView(indexPath: Int) {
        let projectModificationController = ProjectModificationController()
        projectModificationController.indexPath = indexPath
        projectModificationController.viewModel = self.viewModel as? ContentEditable
        projectModificationController.title = viewModel.identifier

        let navigationController = UINavigationController(rootViewController: projectModificationController)
        navigationController.modalPresentationStyle = .formSheet

        self.present(navigationController, animated: true)
    }

    private func configurePopoverController(indexPath: Int, in cell: UITableViewCell) {
        let controller = PopoverController()
        controller.viewModel = self.viewModel as? StatusChangable
        controller.indexPath = indexPath
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.preferredContentSize = CGSize(width: 300, height: 120)
        controller.setTitle(firstButtonName: viewModel.otherTitles[0], secondButtonName: viewModel.otherTitles[1])

        guard let popController = controller.popoverPresentationController else {
            return
        }
        popController.permittedArrowDirections = .up

        popController.delegate = self
        popController.sourceView = view
        popController.sourceRect = CGRect(
            x: cell.frame.midX,
            y: cell.frame.midY,
            width: 0,
            height: 0
        )

        self.present(controller, animated: true)
    }
}

extension ProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        headerView.setupLabelText(section: viewModel.identifier, number: viewModel.count)

        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .normal,
            title: "Delete"
        ) { [weak self] (_, _, success: @escaping (Bool) -> Void) in
            guard let self = self else {
                return
            }
            self.viewModel.delete(indexPath.row)
            
            success(true)
        }
        delete.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [delete])
    }
}
