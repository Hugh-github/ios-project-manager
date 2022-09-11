//
//  ScheduleStackView.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/08.
//

import UIKit

final class ScheduleStackView: UIView {

    // MARK: Properties
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .systemGray4
        
        return stackView
    }()
    
    let toDoView = ScheduleListView()
    let doingView = ScheduleListView()
    let doneView = ScheduleListView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    private func configureView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(toDoView)
        stackView.addArrangedSubview(doingView)
        stackView.addArrangedSubview(doneView)
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
