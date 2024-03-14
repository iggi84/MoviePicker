//
//  ViewStateDelegate.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

protocol ViewStateDelegate: AnyObject {
    func didUpdate(with viewState: ViewState)
}
