//
//  DisplayError.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

enum DisplayError {
    case badResponse
    case serviceError
    case loginError
    case searchTextMissing
}

extension DisplayError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serviceError:
            return "Um this is embarrassing. Service is down please try again."
        case .badResponse:
            return "Um this is embarrassing. Service is down please try again."
        case .loginError:
            return "There was an error with service validation. Please contact your developer."
        case .searchTextMissing:
            return "Search text missing. Please enter valid search text."
        }
    }
}
