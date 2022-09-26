//
//  ProjectManager - ProjectManagerController.swift
//  Created by 수꿍, 휴 on 2022/09/07.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
//import Firebase

final class ProjectManagerController: UIViewController, UIPopoverPresentationControllerDelegate {
//    var ref: DatabaseReference!
//    var todos = ["drink", "eat"]

    let toDoViewModel = ToDoViewModel(databaseManager: LocalDatabaseManager.inMemory)
    let doingViewModel = DoingViewModel(databaseManager: LocalDatabaseManager.inMemory)
    let doneViewModel = DoneViewModel(databaseManager: LocalDatabaseManager.inMemory)

    private lazy var toDoViewController = ProjectListViewController(viewModel: toDoViewModel, controller: controller)
    private lazy var doingViewController = ProjectListViewController(viewModel: doingViewModel, controller: controller)
    private lazy var doneViewController = ProjectListViewController(viewModel: doneViewModel, controller: controller)

    let controller = HistoryPopoverController()

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
//
//        self.ref = Database.database().reference()
//        let itemRef = self.ref.child("list")
//        itemRef.setValue(self.todos)
    }
    
    private func configureNavigationItems() {
        self.title = "Project Manager"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "History",
            style: .plain,
            target: self,
            action: #selector(configurePopoverController)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    @objc private func configurePopoverController(_ sender: UIBarButtonItem) {

        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.toDoViewModel = self.toDoViewModel
        controller.doingViewModel = self.doingViewModel
        controller.doneViewModel = self.doneViewModel
        //                controller.preferredContentSize = CGSize(width: 300, height: 120)
        
        guard let popController = controller.popoverPresentationController else {
            return
        }
        
        popController.permittedArrowDirections = .up
        
        popController.delegate = self
        popController.sourceView = view
        popController.barButtonItem = sender

        self.present(controller, animated: true)
    }

    @objc func didTapAddButton() {
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

}
