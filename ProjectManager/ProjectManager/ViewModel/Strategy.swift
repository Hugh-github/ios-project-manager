//
//  Strategy.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/21.
//

import Foundation

protocol State {
    var count: Int { get }

    func delete(_ indexPath: Int)
    func fetch(_ indexPath: Int) -> ProjectUnit?
    func edit(
        indexPath: Int,
        title: String,
        body: String,
        date: Date
    )
}

struct ToDo: State {
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
}
