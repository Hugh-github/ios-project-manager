//
//  ViewModel.swift
//  ProjectManager
//
//  Created by dhoney96 on 2022/09/22.
//

import Foundation

class ViewModel {
    var data: Observable<[ProjectUnit]> = Observable([])
    
    let dataManager: DatabaseLogic
    
    init(dataManager: DatabaseLogic) {
        self.dataManager = dataManager
    }
    
    func fetchTodoData(data: [ProjectUnit]) -> [ProjectUnit] {
        return data.filter { projectUnit in
            projectUnit.section == "TODO"
        }
    }
    
    func fetchDoingData(data: [ProjectUnit]) -> [ProjectUnit] {
        return data.filter { projectUnit in
            projectUnit.section == "DOING"
        }
    }
    
    func fetchDoneData(data: [ProjectUnit]) -> [ProjectUnit] {
        return data.filter { projectUnit in
            projectUnit.section == "DONE"
        }
    }
    
    func fetchTodoCount() -> Int {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "TODO"
        }.count
    }
    
    func fetchDoingCount() -> Int {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "DOING"
        }.count
    }
    
    func fetchDoneCount() -> Int {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "DONE"
        }.count
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
            section: Section.todo,
            deadLine: date
        )
        data.value.append(project)
        do {
            try dataManager.create(data: project)
        } catch {
            print(error)
        }
    }
    
    func delete(_ indexPath: Int) {
        let data = data.value.remove(at: indexPath)
        
        do {
            try dataManager.delete(id: data.id)
        } catch {
            print(error)
        }
    }

    func fetchTodoData(_ indexPath: Int) -> ProjectUnit? {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "TODO"
        }[indexPath]
    }
    
    func fetchDoingData(_ indexPath: Int) -> ProjectUnit? {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "DOING"
        }[indexPath]
    }
    
    func fetchDoneData(_ indexPath: Int) -> ProjectUnit? {
        return self.data.value.filter { projectUnit in
            projectUnit.section == "DONE"
        }[indexPath]
    }
    
    func edit(
        indexPath: Int,
        title: String,
        body: String,
        date: Date
    ) {
        data.value[indexPath].title = title
        data.value[indexPath].body = body
        data.value[indexPath].deadLine = date
        
        let data = data.value[indexPath]
        do {
            try dataManager.update(data: data)
        } catch {
            print(error)
        }
    }
    
    func readjust(index: Int, section: String) {
        self.data.value[index].section = section
    }
    
    func isPassDeadLine(_ deadLine: Date) -> Bool {
        if deadLine < Date() {
            return true
        }

        return false
    }
}
