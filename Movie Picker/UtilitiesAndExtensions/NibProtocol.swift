//
//  NibProtocol.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation
import UIKit

protocol NibProtocol: Identifiable {
    static var nib: UINib { get }
}

extension NibProtocol {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
