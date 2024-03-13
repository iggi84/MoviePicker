//
//  ViewController.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 11.3.24..
//

import UIKit

class MoviesList: UIViewController {

    // MARK: - Oulets
    
    // MARK: - Properties
    
    private let viewModel = MovieListViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - ViewStateDelegate

extension MoviesList: ViewStateDelegate {
    
    func didUpdate(with viewState: ViewState) {
    }
}

