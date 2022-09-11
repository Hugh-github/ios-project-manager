//
//  ProjectModificationViewController.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/10.
//

import UIKit

final class ProjectModificationViewController: UIViewController {

    override func loadView() {
        view = ScheduleModificationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        self.title = "TODO"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTappedEditButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedDoneButton)
        )
    }
    
    @objc private func didTappedEditButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTappedDoneButton() {
        dismiss(animated: true)
    }
}
