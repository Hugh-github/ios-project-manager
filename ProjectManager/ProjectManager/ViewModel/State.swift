//
//  State.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/21.
//

import Foundation

protocol State {
    var identifier: String? { get }
    var count: Int { get }

    func delete(_ indexPath: Int)
    func fetch(_ indexPath: Int) -> ProjectUnit?
    func edit(
        indexPath: Int,
        title: String,
        body: String,
        date: Date
    )
    func move(indexPath: Int, from currentSection: String, to nextSection: String)
}

extension State {
    var identifier: String? {
        guard let identifier = String(describing: self)
            .split(separator: "(")
            .first?
            .uppercased() else {
            return nil
        }

        return String(identifier)
    }
}

struct ToDo: State {
    func move(indexPath: Int, from currentSection: String, to nextSection: String) {
        var data: ProjectUnit?

        switch (currentSection, nextSection) {
        case ("TODO", "DOING"):
            data = viewModel.toDoData.value.remove(at: indexPath)

            if let data = data {
                viewModel.doingData.value.append(data)
            }
        default:
            return
        }

        guard let data = data else {
            return
        }

        do {
            try viewModel.databaseManager.update(data: data)
        } catch {
            viewModel.message = "Add Error"
        }
    }

    //    func readjust(index: Int, section: String) {
    //        let data = doneData.value.remove(at: index)
    //
    //        switch section {
    //        case Section.todo:
    //            NotificationCenter.default.post(name: Notification.Name.doneToToDo, object: data)
    //        case Section.doing:
    //            NotificationCenter.default.post(name: Notification.Name.doneToDoing, object: data)
    //        default:
    //            return
    //        }
    //    }

    //    @objc func addData(_ notification: Notification) {
    //        guard var projectUnit = notification.object as? ProjectUnit else {
    //            return
    //        }
    //
    //        projectUnit.section = Section.done
    //
    //        doneData.value.append(projectUnit)
    //
    //        do {
    //            try databaseManager.update(data: projectUnit)
    //        } catch {
    //            message = "Add Error"
    //        }
    //    }

    private var viewModel: ViewModel

    var count: Int {
        return viewModel.toDoData.value.count
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func delete(_ indexPath: Int) {
        let data = viewModel.toDoData.value.remove(at: indexPath)

        do {
            try viewModel.databaseManager.delete(id: data.id)
        } catch {
            viewModel.message = "Delete Error"
        }
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        viewModel.toDoData.value[indexPath]
    }

    func edit(indexPath: Int, title: String, body: String, date: Date) {
        var data = viewModel.toDoData.value[indexPath]
        data.title = title
        data.body = body
        data.deadLine = date

        viewModel.toDoData.value[indexPath] = data
        do {
            try viewModel.databaseManager.update(data: data)
        } catch {
            viewModel.message = "Edit Error"
        }
    }
}

struct Doing: State {
    private var viewModel: ViewModel

    var count: Int {
        return viewModel.doingData.value.count
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func delete(_ indexPath: Int) {
        let data = viewModel.doingData.value.remove(at: indexPath)

        do {
            try viewModel.databaseManager.delete(id: data.id)
        } catch {
            viewModel.message = "Delete Error"
        }
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        viewModel.doingData.value[indexPath]
    }

    func edit(indexPath: Int, title: String, body: String, date: Date) {
        var data = viewModel.doingData.value[indexPath]
        data.title = title
        data.body = body
        data.deadLine = date

        viewModel.doingData.value[indexPath] = data
        do {
            try viewModel.databaseManager.update(data: data)
        } catch {
            viewModel.message = "Edit Error"
        }
    }

    func move(indexPath: Int, from currentSection: String, to nextSection: String) {
        switch (currentSection, nextSection) {
        case ("ToDo", "Doing"):
            let data = viewModel.toDoData.value.remove(at: indexPath)
            viewModel.doingData.value.append(data)

            do {
                try viewModel.databaseManager.update(data: data)
            } catch {
                viewModel.message = "Add Error"
            }
        default:
            return
        }
    }
}

struct Done: State {
    private var viewModel: ViewModel

    var count: Int {
        return viewModel.doneData.value.count
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func delete(_ indexPath: Int) {
        let data = viewModel.doneData.value.remove(at: indexPath)

        do {
            try viewModel.databaseManager.delete(id: data.id)
        } catch {
            viewModel.message = "Delete Error"
        }
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        viewModel.doneData.value[indexPath]
    }

    func edit(indexPath: Int, title: String, body: String, date: Date) {
        var data = viewModel.doneData.value[indexPath]
        data.title = title
        data.body = body
        data.deadLine = date

        viewModel.doneData.value[indexPath] = data
        do {
            try viewModel.databaseManager.update(data: data)
        } catch {
            viewModel.message = "Edit Error"
        }
    }

    func move(indexPath: Int, from currentSection: String, to nextSection: String) {
        switch (currentSection, nextSection) {
        case ("ToDo", "Doing"):
            let data = viewModel.toDoData.value.remove(at: indexPath)
            viewModel.doingData.value.append(data)

            do {
                try viewModel.databaseManager.update(data: data)
            } catch {
                viewModel.message = "Add Error"
            }
        default:
            return
        }
    }
}
