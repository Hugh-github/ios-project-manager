//
//  DoneViewModel.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/17.
//

import Foundation

final class DoneViewModel: CommonViewModelLogic, ContentEditable, StatusChangable {
    var registerDeletionHistory: (() -> Void)?

    var calledContentsOfMoving: (String, String)? {
        didSet {
            guard let registerMovingHistory = self.registerMovingHistory,
                  let a = calledContentsOfMoving else {
                return
            }

            let b = a.1
            let c = b.components(separatedBy: ["t", "o"])

            registerMovingHistory(a.0, c.first!, c.last!)
        }
    }

    var registerMovingHistory: ((String, String, String) -> Void)?

    let identifier: String = ProjectStatus.done
    let data: Observable<[ProjectUnit]> = Observable([])
    let databaseManager: LocalDatabaseManager
    
    var message: String = "" {
        didSet {
            guard let showAlert = self.showAlert else {
                return
            }
            showAlert()
        }
    }
    
    var showAlert: (() -> Void)?
    
    init(databaseManager: LocalDatabaseManager) {
        self.databaseManager = databaseManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name.toDoToDone,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name.doingToDone,
            object: nil
        )
    }
    
    @objc func addData(_ notification: Notification) {
        guard var projectUnit = notification.object as? ProjectUnit else {
            return
        }
        
        projectUnit.section = identifier

        calledContentsOfMoving = (projectUnit.title, notification.name.rawValue)
        
        self.data.value.append(projectUnit)
        
        do {
            try databaseManager.update(data: projectUnit)
        } catch {
            message = "Add Error"
        }
    }

    func change(index: Int, status: String) {
        let data = data.value.remove(at: index)

        switch status {
        case ProjectStatus.todo:
            NotificationCenter.default.post(name: Notification.Name.doneToToDo, object: data)
        case ProjectStatus.doing:
            NotificationCenter.default.post(name: Notification.Name.doneToDoing, object: data)
        default:
            return
        }
    }
}
