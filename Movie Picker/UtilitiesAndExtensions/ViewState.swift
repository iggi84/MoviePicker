//
//  ViewState.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

enum ViewState {
    case idle
    case emptyList
    case loadingData
    case success
    case offline
    case error(DisplayError)
}
