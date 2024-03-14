//
//  DBController.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 14.3.24..
//

import Foundation
import CoreData

final class DBController {
    
    // MARK: - Singletone
    
    static let shared = DBController()
    
    // MARK: - Properties
    
    private var container: NSPersistentContainer
    
    // MARK: - Init
    
    init() {
        container = NSPersistentContainer(name: "Movie_Picker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Error while creating Persistance layer: \(error)")
            }
        }
    }
    
    // MARK: - API
    
    func saveMovies(from movies: [MovieResponse]?) {
        guard let movies else {
            return
        }
        
        for movie in movies {
            saveMovie(movie: movie)
        }
    }
    
    func saveMovie(movie: MovieResponse) {
        if getMovie(for: movie.id ?? -1) == nil {
            let newMovie = SavedMovie(context: DBController.shared.container.viewContext)
            newMovie.id = Int64(movie.id ?? -1)
            newMovie.adult = movie.adult ?? false
            newMovie.originalLanguage = movie.originalLanguage ?? ""
            newMovie.originalTitle = movie.originalTitle ?? ""
            newMovie.overview = movie.overview ?? ""
            newMovie.popularity = movie.popularity ?? -1
            newMovie.adult = movie.adult ?? false
            newMovie.posterPath = movie.posterPath ?? ""
            newMovie.releaseDate = movie.releaseDate ?? ""
            newMovie.title = movie.title ?? ""
            newMovie.video = movie.video ?? false
            newMovie.voteAverage = movie.voteAverage ?? -1
            newMovie.voteCount = Int64(movie.voteCount ?? -1)
            saveContext()
        }
    }
    
    func getSavedMovies(for movieName: String) -> [MovieResponse]? {
        let fetchRequest = SavedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", movieName)
        do {
            let savedMovies = try container.viewContext.fetch(fetchRequest)
            let movies = savedMovies.map { savedMovie in
                MovieResponse(adult: savedMovie.adult , id: Int(savedMovie.id), originalLanguage: savedMovie.originalLanguage, originalTitle: savedMovie.originalTitle, overview: savedMovie.overview, popularity: savedMovie.popularity, posterPath: savedMovie.posterPath, releaseDate: savedMovie.releaseDate, title: savedMovie.title, video: savedMovie.video, voteAverage: savedMovie.voteAverage, voteCount: Int(savedMovie.voteCount))
            }
            return movies
        } catch {
            print("Error while getting requested Movies data")
        }
        return nil
    }
        
    private func getMovie(for id: Int) -> SavedMovie? {
        let fetchRequest = SavedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        do {
            let movies = try container.viewContext.fetch(fetchRequest)
            if let movie =  movies.first {
                return movie
            } else { return nil }
        } catch {
            print("Error while getting requested Movies data")
        }
        return nil
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error while saving context:\(error)")
            }
        }
    }
    
}
