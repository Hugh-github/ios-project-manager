//
//  ToDoViewModel.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/17.
//

import Foundation

final class ToDoViewModel: Readjustable {
    var toDoData: Observable<[ProjectUnit]> = Observable([])
    
    var count: Int {
        return toDoData.value.count
    }

    let databaseManager: DatabaseLogic

    init(databaseManager: DatabaseLogic) {
        self.databaseManager = databaseManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name("DOINGtoTODO"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name("DONEtoTODO"),
            object: nil
        )
        fetchToDoData()
    }
    
    @objc func addData(_ notification: Notification) {
        guard var projectUnit = notification.object as? ProjectUnit else {
            return
        }
        
        projectUnit.section = "DOING"
        
        toDoData.value.append(projectUnit)
        
        do {
            try databaseManager.update(data: projectUnit)
        } catch {
            print(error)
        }
    }

    func addProject(
        title: String,
        body: String,
        date: Date
    ) {
        let project = ProjectUnit(
            id: UUID(),
            title: title,
            body: body,
            section: "TODO",
            deadLine: date
        )
        toDoData.value.append(project)
        try? databaseManager.create(data: project)
    }

    func delete(_ indexPath: Int) {
        let data = toDoData.value.remove(at: indexPath)
        try? databaseManager.delete(id: data.id)
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        toDoData.value[indexPath]
    }

    private func fetchToDoData() {
        do {
            try databaseManager.fetchSection("TODO").forEach { project in
                toDoData.value.append(project)
            }
        } catch {
            print(error)
        }
    }
    
    func readjust(index: Int, section: String) {
        let data = toDoData.value.remove(at: index)
        
        do {
            try databaseManager.delete(id: data.id)
        } catch {
            print(error)
        }
        
        switch section {
        case "DOING":
            NotificationCenter.default.post(name: Notification.Name("TODOtoDOING"), object: data)
        case "DONE":
            NotificationCenter.default.post(name: Notification.Name("TODOtoDONE"), object: data)
        default:
            return
        }
    }
}
