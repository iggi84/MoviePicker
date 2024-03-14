//
//  Endpoint.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation
import UIKit

enum Endpoint {
    case search
    case image
    var baseURL: String {
        return UIApplication.baseURL
    }
    
    var imageBaseURL: String {
        return UIApplication.imageBaseURL
    }
    
    func imageURL(for imagePath: String, imageSize: ImageSize) -> URL? {
        return URL(string: "\(url)\(imageSize.rawValue)\(imagePath)")
    }
    
    var path: String {
        switch self {
        case .search:
            return "search/movie"
        case .image:
            return "t/p/"
        }
    }
    
    var url: String {
        switch self {
        case .search:
            return "\(baseURL)\(path)"
        case .image:
            return "\(imageBaseURL)\(path)"
        }
    }
}
