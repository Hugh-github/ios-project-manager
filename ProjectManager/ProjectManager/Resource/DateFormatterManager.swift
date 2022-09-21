//
//  DateFormatterManager.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/21.
//

import Foundation

final class DateFormatterManager {
    let formatter = DateFormatter()
    let locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko")

    var dateFormatter: DateFormatter {
        get {
            formatter.locale = locale
            formatter.dateStyle = .long
            
            return formatter
        }
    }

    static let sharedManager = DateFormatterManager()

    func dateStringFromDate(date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
}
