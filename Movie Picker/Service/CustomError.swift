//
//  CustomError.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

public enum CustomError: Error {
    case badResponse
    case statusCode(Int)
    case searchTextMissing
    case timeout
    case unknown
}
