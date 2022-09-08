//
//  ProjectManager - ViewController.swift
//  Created by 수꿍, 휴 on 2022/09/07.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private enum Section: String, CaseIterable {
        case toDo = "ToDo"
        case doing = "Doing"
        case done = "Done"
    }

    private var collectionView: UICollectionView!
    private var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: view.frame.width * 0.33, height: view.frame.height)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView?.isScrollEnabled = false
        collectionView?.dataSource = self
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "FirstSection")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstSection", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            cell.backgroundColor = .red
        } else if indexPath.section == 1 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .green
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
