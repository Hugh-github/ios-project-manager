//
//  ProjectManager - ProjectManagerController.swift
//  Created by 수꿍, 휴 on 2022/09/07.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProjectManagerController: UIViewController {
    let viewModel = ViewModel(databaseManager: MockLocalDatabaseManager.shared)

//    private let toDoViewController = ToDoViewController(viewModel: self.viewModel)
    private lazy var toDoViewController = {
        self.viewModel.changeState(to: ToDo(viewModel: self.viewModel))
        let vc = ToDoViewController(viewModel: viewModel)

        return vc
    }()

    private lazy var doingViewController = {
        self.viewModel.changeState(to: Doing(viewModel: self.viewModel))
        let vc = DoingViewController(viewModel: self.viewModel)

        return vc
    }()

    private lazy var doneViewController = {
        self.viewModel.changeState(to: Done(viewModel: self.viewModel))
        let vc = DoneViewController(viewModel: self.viewModel)

        return vc
    }()

//    private lazy var doneViewController = DoneViewController(viewModel: viewModel)
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
//        toDoViewController = ToDoViewController(viewModel: viewModel)
//        doingViewController = DoingViewController(viewModel: viewModel)
//        doneViewController = DoneViewController(viewModel: viewModel)
    }
    
    private func configureNavigationItems() {
        self.title = "Project Manager"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    @objc func didTapAddButton() {
        let projectAdditionController = ProjectAdditionController()
        projectAdditionController.viewModel = self.viewModel

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
