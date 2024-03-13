//
//  MovieDetailsViewModel.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation

class MovieDetailsViewModel {
    
    // MARK: - properties
    
    var movie: MovieResponse?
    
    // MARK: - Init
    
    init(movie: MovieResponse?) {
        self.movie = movie
    }
}
