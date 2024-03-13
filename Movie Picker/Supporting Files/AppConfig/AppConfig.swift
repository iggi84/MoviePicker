//
//  AppConfig.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 11.3.24..
//

import UIKit

extension UIApplication {
    
    // MARK: - Properties
    
    class var config: NSDictionary {
        return Bundle.main.object(forInfoDictionaryKey: "Config") as! NSDictionary
    }
    
    @objc class var baseURL: String {
        guard let baseURL = config["BaseURL"] as? String else {
            return ""
        }
        return baseURL
    }
    
    @objc class var imageBaseURL: String {
        guard let baseURL = config["ImageBaseURL"] as? String else {
            return ""
        }
        return baseURL
    }
    
    @objc class var apiToken: String {
        guard let apiToken = config["APIToken"] as? String else {
            return ""
        }
        return apiToken
    }
}
