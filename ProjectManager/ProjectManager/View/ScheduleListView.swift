//
//  ScheduleListView.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/08.
//

import UIKit

final class ScheduleListView: UIView {
    
    // MARK: Properties
    
    var tableView = UITableView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTableView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    private func configureTableView() {
        tableView = UITableView(frame: bounds,
                                style: .plain)
        tableView.backgroundColor = .systemGray6
        addSubview(tableView)
    }
    
    private func configureUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
