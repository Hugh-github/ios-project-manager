//
//  DoneViewModel.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/17.
//

import Foundation

//final class DoneViewModel: Readjustable, Editable {
//    var doneData: Observable<[ProjectUnit]> = Observable([])
//
//    var count: Int {
//        return doneData.value.count
//    }
//
//    var message: String = "" {
//        didSet {
//            guard let showAlert = showAlert else {
//                return
//            }
//
//            showAlert()
//        }
//    }
//
//    let databaseManager: DatabaseLogic
//
//    var showAlert: (() -> Void)?
//
//    init(databaseManager: DatabaseLogic) {
//        self.databaseManager = databaseManager
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(addData(_:)),
//            name: Notification.Name.toDoToDone,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(addData(_:)),
//            name: Notification.Name.doingToDone,
//            object: nil
//        )
//        fetchDoneData()
//    }
//
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
//
//    func delete(_ indexPath: Int) {
//        let data = doneData.value.remove(at: indexPath)
//
//        do {
//            try databaseManager.delete(id: data.id)
//        } catch {
//            message = "Delete Error"
//        }
//    }
//
//    func fetch(_ indexPath: Int) -> ProjectUnit? {
//        doneData.value[indexPath]
//    }
//
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
//
//    func edit(
//        indexPath: Int,
//        title: String,
//        body: String,
//        date: Date
//    ) {
//        var data = doneData.value[indexPath]
//        data.title = title
//        data.body = body
//        data.deadLine = date
//
//        doneData.value[indexPath] = data
//        do {
//            try databaseManager.update(data: data)
//        } catch {
//            message = "Edit Error"
//        }
//    }
//
//    func isPassDeadLine(_ deadLine: Date) -> Bool {
//        if deadLine < Date() {
//            return true
//        }
//
//        return false
//    }
//
//    private func fetchDoneData() {
//        do {
//            try databaseManager.fetchSection(Section.done).forEach { project in
//                doneData.value.append(project)
//            }
//        } catch {
//            message = "Fetch Error"
//        }
//    }
//}
