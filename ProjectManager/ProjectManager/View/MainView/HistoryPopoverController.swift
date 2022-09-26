//
//  HistoryPopoverController.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/26.
//

import UIKit

final class HistoryPopoverController: UIViewController, UIPopoverPresentationControllerDelegate {
    enum Schedule {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Schedule, ProjectHistoryUnit>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, ProjectHistoryUnit>

    var dataSource: DataSource?
    var snapshot: Snapshot?
    var toDoViewModel: ToDoViewModel?
    var doingViewModel: DoingViewModel?
    var doneViewModel: DoneViewModel?
    var historyData: [ProjectHistoryUnit] = []

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6

        return tableView
    }()

    override func viewDidLoad() {
        configureUI()
        configureDataSource()
//        configureObserver()
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
        tableView.register(cellType: ProjectHistoryListCell.self)
        tableView.delegate = self

        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: ProjectHistoryListCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setContents(
                    title: item.content,
                    date: item.time.localizedString
                )

                cell.separatorInset = .zero

                return cell
            }
        )
    }

    func configureSnapshot(data: [ProjectHistoryUnit]) -> Snapshot {
        var snapshot = Snapshot()
        historyData.append(data.first!)
        snapshot.appendSections([.main])
        snapshot.appendItems(historyData)

        return snapshot
    }

//    private func configureObserver() {
//        toDoViewModel?.registerMovingHistory = { [weak self] (title, transition) in
//            guard let self = self else {
//                return
//            }
//
//            self.snapshot = self.configureSnapshot(data: [ProjectHistoryUnit(content: title + transition, time: Date())])
//
//            guard let snapshot = self.snapshot else {
//                return
//            }
//
//            self.dataSource?.apply(snapshot)
//            self.tableView.reloadData()
//        }
//    }
}

extension HistoryPopoverController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct ProjectHistoryUnit: Hashable {
    var content: String
    var time: Date

    init(
        content: String,
        time: Date
    ) {
        self.content = content
        self.time = time
    }
}
