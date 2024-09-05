//
//  Segues.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 5.9.24..
//

import UIKit

protocol Segues {
  associatedtype SegueIdentifier: RawRepresentable
}

extension Segues where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueId(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError() }
        
        return segueIdentifier
    }
    
}
