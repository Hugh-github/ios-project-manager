//
//  ProjectAdditionViewController.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/10.
//

import UIKit

final class ProjectAdditionViewController: UIViewController {

    override func loadView() {
        view = AdditionalScheduleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        self.title = "TODO"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTappedCancelButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedDoneButton)
        )
    }
    
    @objc private func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTappedDoneButton() {
        dismiss(animated: true)
    }
}
