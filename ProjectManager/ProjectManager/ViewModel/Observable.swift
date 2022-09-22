//
//  Observable.swift
//  ProjectManager
//
//  Created by 수꿍, 휴 on 2022/09/15.
//

final class Observable<T> {
    var value: T {
        didSet {
            self.toDoListener?(value)
            self.doingListener?(value)
            self.doneListener?(value)
        }
    }

    var toDoListener: ((T) -> Void)?
    var doingListener: ((T) -> Void)?
    var doneListener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }

    func subscribeTodo(listener: @escaping (T) -> Void) {
        listener(value)
        self.toDoListener = listener
    }
    
    func subscribeDoing(listener: @escaping (T) -> Void) {
        listener(value)
        self.doingListener = listener
    }
    
    func subscribeDone(listener: @escaping (T) -> Void) {
        listener(value)
        self.doneListener = listener
    }
}
