//
//  ViewModel.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/21.
//

import Foundation

final class ViewModel {
    private var state: State?

    var toDoData: Observable<[ProjectUnit]> = Observable([])
    var doingData: Observable<[ProjectUnit]> = Observable([])
    var doneData: Observable<[ProjectUnit]> = Observable([])

    var count: Int? {
        return state?.count
    }

    var message: String = "" {
        didSet {
            guard let showAlert = showAlert else {
                return
            }

            showAlert()
        }
    }

    let databaseManager: DatabaseLogic

    var showAlert: (() -> Void)?

    init(databaseManager: DatabaseLogic) {
        self.databaseManager = databaseManager
        fetchData()
    }

    func delete(_ indexPath: Int) {
        state?.delete(indexPath)
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        state?.fetch(indexPath)
    }

    func edit(
        indexPath: Int,
        title: String,
        body: String,
        date: Date
    ) {
        state?.edit(indexPath: indexPath, title: title, body: body, date: date)
    }

    func changeState(to state: State) {
        self.state = state
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
        toDoData.value.append(project)

        do {
            try databaseManager.create(data: project)
        } catch {
            message = "Add Entity Error"
        }
    }

    private func fetchData() {
        do {
            try databaseManager.fetchData().forEach { projectUnit in
                switch projectUnit.section {
                case "ToDo":
                    toDoData.value.append(projectUnit)
                case "Doing":
                    doingData.value.append(projectUnit)
                case "Done":
                    doneData.value.append(projectUnit)
                default:
                    return
                }
            }
        } catch {
            message = "Fetch Error"
        }
    }
}
