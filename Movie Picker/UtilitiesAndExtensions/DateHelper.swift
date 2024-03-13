//
//  DateHelper.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

class DateHelper {
    
    // MARK: - Properties
    
    var dateFormatter = DateFormatter()
    
    // MARK: - Singleton
    
    static let shared = DateHelper()
    
    // MARK: Init
    
    init() {
        dateFormatter = DateFormatter()
    }
    
    func formatDate(dateString: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
