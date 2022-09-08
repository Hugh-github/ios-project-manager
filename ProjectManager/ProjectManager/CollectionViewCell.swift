//
//  CollectionViewCell.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/08.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    private var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
        self.contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            customView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
            customView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            customView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30)
        ])
    }
}
