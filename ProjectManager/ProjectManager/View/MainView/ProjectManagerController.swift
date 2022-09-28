//
//  ProjectManager - ProjectManagerController.swift
//  Created by 수꿍, 휴 on 2022/09/07.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Firebase

final class ProjectManagerController: UIViewController, UIPopoverPresentationControllerDelegate {

    var ref: DatabaseReference!

    private let toDoViewModel = ToDoViewModel(databaseManager: LocalDatabaseManager.onDisk)
    private let doingViewModel = DoingViewModel(databaseManager: LocalDatabaseManager.onDisk)
    private let doneViewModel = DoneViewModel(databaseManager: LocalDatabaseManager.onDisk)

    private lazy var toDoViewController = ProjectListViewController(
        viewModel: toDoViewModel)
    private lazy var doingViewController = ProjectListViewController(
        viewModel: doingViewModel)
    private lazy var doneViewController = ProjectListViewController(
        viewModel: doneViewModel)

    private let historyController = HistoryPopoverController()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemGray4
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureUI()
        configureObservers()

        ref = Database.database().reference()
        //        ref.child("user").child("1번 User").setValue(["username": "Minsoo"])
        //        self.ref = Database.database().reference()
        //        let itemRef = self.ref.child("list")
        //        itemRef.setValue(self.todos)


        // MARK: Remote로 저장(덮어쓰기)하기 위한 Encoding
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let sookoong = ProjectUnit.sample
        let jsonData = try? encoder.encode(sookoong)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            ref.child("project").child("sample project1").setValue(jsonString)
        }

        // MARK: Remote에서 불러오기 위한 Decoding (데이터가 한 번만 필요한 경우 -> get Data)
        // 데이터를 지속적으로 읽기 위해서는 Observer를 사용하여 데이터 한 번 읽기
        let decoder = JSONDecoder()

        ref.child("project/sample project1").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let sample = snapshot?.value as? String ?? "Unknown";
            let data = sample.data(using: .utf8)

            if let data = data, let finalSampleData = try? decoder.decode(ProjectUnit.self, from: data) {
                print(finalSampleData.title)
                print(finalSampleData.body)
                print(finalSampleData.id)
                print(finalSampleData.deadLine)
                print(finalSampleData.section)
            }
        })
    }
    
    private func configureNavigationItems() {
        self.title = "Project Manager"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "History",
            style: .plain,
            target: self,
            action: #selector(didTapHistoryButton)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    @objc private func didTapHistoryButton() {
        historyController.modalPresentationStyle = .popover
        historyController.preferredContentSize = CGSize(width: 600, height: 600)
        
        guard let popoverController = historyController.popoverPresentationController else {
            return
        }
        
        popoverController.delegate = self
        popoverController.permittedArrowDirections = .up
        popoverController.sourceView = self.view
        popoverController.barButtonItem = navigationItem.leftBarButtonItem
        
        self.present(historyController, animated: true)
    }
    
    @objc private func didTapAddButton() {
        let projectAdditionController = ProjectAdditionController()
        projectAdditionController.viewModel = self.toDoViewController.viewModel as? ContentAddible

        let navigationController = UINavigationController(rootViewController: projectAdditionController)
        navigationController.modalPresentationStyle = .formSheet

        self.present(navigationController, animated: true)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(stackView)
        self.stackView.addArrangedSubview(toDoViewController.view)
        self.stackView.addArrangedSubview(doingViewController.view)
        self.stackView.addArrangedSubview(doneViewController.view)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureObserver(in viewModel: CommonViewModelLogic) {
        viewModel.registerMovingHistory = { [weak self] (title, previous, next) in
            self?.historyController.configureSnapshotItem(data: HistoryLog(
                content: "Moved '\(title)' from \(previous) to \(next).",
                time: Date())
            )

            guard let snapshot = self?.historyController.snapshot else {
                return
            }

            self?.historyController.dataSource?.apply(snapshot)
            self?.historyController.tableView.reloadData()
        }

        viewModel.registerDeletionHistory = { [weak self] (title, schedule) in
            self?.historyController.configureSnapshotItem(data: HistoryLog(
                content: "Removed '\(title)' from \(schedule)",
                time: Date())
            )

            guard let snapshot = self?.historyController.snapshot else {
                return
            }

            self?.historyController.dataSource?.apply(snapshot)
            self?.historyController.tableView.reloadData()
        }

        guard var viewModel = viewModel as? ContentAddible else {
            return
        }

        viewModel.registerAdditionHistory = { [weak self] (title) in
            self?.historyController.configureSnapshotItem(data: HistoryLog(
                content: "Added '\(title)'.",
                time: Date())
            )

            guard let snapshot = self?.historyController.snapshot else {
                return
            }

            self?.historyController.dataSource?.apply(snapshot)
            self?.historyController.tableView.reloadData()
        }
    }

    private func configureObservers() {
        configureObserver(in: toDoViewModel)
        configureObserver(in: doingViewModel)
        configureObserver(in: doneViewModel)
    }
}
