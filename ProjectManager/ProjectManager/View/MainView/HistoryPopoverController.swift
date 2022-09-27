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

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6

        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureDataSource()

        snapshot = Snapshot()
        snapshot?.appendSections([.main])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func configureSnapshot(data: [ProjectHistoryUnit]) {
        snapshot?.appendItems(data)
    }
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
