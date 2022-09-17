//
//  DoneViewModel.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/17.
//

import Foundation

final class DoneViewModel: Readjustable, Editable {
    var doneData: Observable<[ProjectUnit]> = Observable([])
    
    var count: Int {
        return doneData.value.count
    }

    let databaseManager: DatabaseLogic

    init(databaseManager: DatabaseLogic) {
        self.databaseManager = databaseManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name("TODOtoDONE"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addData(_:)),
            name: Notification.Name("DOINGtoDONE"),
            object: nil
        )
        fetchDoneData()
    }
    
    @objc func addData(_ notification: Notification) {
        guard var projectUnit = notification.object as? ProjectUnit else {
            return
        }
        
        projectUnit.section = "DONE"
        
        doneData.value.append(projectUnit)
        
        do {
            try databaseManager.update(data: projectUnit)
        } catch {
            print(error)
        }
    }

    func delete(_ indexPath: Int) {
        let data = doneData.value.remove(at: indexPath)
        try? databaseManager.delete(id: data.id)
    }

    func fetch(_ indexPath: Int) -> ProjectUnit? {
        doneData.value[indexPath]
    }

    private func fetchDoneData() {
        do {
            try databaseManager.fetchSection("DONE").forEach { project in
                doneData.value.append(project)
            }
        } catch {
            print(error)
        }
    }
    
    func readjust(index: Int, section: String) {
        let data = doneData.value.remove(at: index)

        switch section {
        case "TODO":
            NotificationCenter.default.post(name: Notification.Name("DONEtoTODO"), object: data)
        case "DOING":
            NotificationCenter.default.post(name: Notification.Name("DONEtoDOING"), object: data)
        default:
            return
        }
    }

    func edit(
        indexPath: Int,
        title: String,
        body: String,
        date: Date
    ) {
        var data = doneData.value[indexPath]
        data.title = title
        data.body = body
        data.deadLine = date
        
        doneData.value[indexPath] = data
        do {
            try databaseManager.update(data: data)
        } catch {
            print(error)
        }
    }

    func isPassDeadLine(_ deadLine: Date) -> Bool {
        if deadLine < Date() {
            return true
        }

        return false
    }
}
