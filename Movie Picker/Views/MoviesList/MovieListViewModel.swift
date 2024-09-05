//
//  MovieListViewModel.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import Foundation
import UIKit
import Alamofire

final class MovieListViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ViewStateDelegate?
    private var viewState: ViewState {
        didSet {
            delegate?.didUpdate(with: viewState)
        }
    }
    private var searchedMovies: [MovieResponse] = []
    private var currentPage = 1
    private var isLocadingData = false
    private var hasNext = true
    var selectedMovie: MovieResponse?
    
    // MARK: - Init
    
    init() {
        self.viewState = .idle
    }
}

// MARK: - Data source for table

extension MovieListViewModel {
    
    var numberOfMovies: Int {
        return searchedMovies.count
    }
    
    func getMovie(for index: IndexPath) -> MovieResponse {
        return searchedMovies[index.row]
    }
    
    func selectMovie(at index: IndexPath) {
        selectedMovie = getMovie(for: index)
    }
}

// MARK: - Network Service

extension MovieListViewModel {
    
    @MainActor
    func searchMovie(for movieName: String) {
        viewState = .loadingData
        
        if !Reachability.isConnectedToNetwork() {
            searchedMovies.removeAll()
            if let movies = DBController.shared.getSavedMovies(for: movieName) {
                searchedMovies.append(contentsOf: movies)
                viewState = .offline
            }
        }
        
        let searchParams = [
            "query" : movieName,
            "page" : currentPage
        ] as [String : Any]
        Task {
            do {
                let searchResponse = try await Network.mainService.getRequest(to: Endpoint.search.url, parameters: searchParams, headers: generateHeaders(), expectedReturnType: SearchResponse.self)
                if let movies = searchResponse.results {
                    searchedMovies.append(contentsOf: movies)
                    viewState = .success
                } else {
                    viewState = .emptyList
                }
                
            } catch {
                print("Error!")
                handleBadResponse(with: error as? CustomError)
            }
        }
    }
    
    @MainActor
    func refreshMovies(for movieName: String) {
        currentPage = 1
        hasNext = true
        isLocadingData = false
        searchedMovies.removeAll()
        searchMovie(for: movieName)
    }
    
    func resetSearchParams() {
        currentPage = 1
        hasNext = true
        isLocadingData = false
        searchedMovies.removeAll()
        viewState = .idle
    }
    
    func loadNextPage(from scrollView: UIScrollView, movieName: String) {
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            return
        }
           
        guard
              !searchedMovies.isEmpty,
              !isLocadingData,
              hasNext
        else {
            return
        }
        isLocadingData = true
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                Task{ [weak self] in
                    await self?.searchMovie(for: movieName)
                }
            }
            t.invalidate()
        }

    }
    
    // MARK: - Helpers
    
    private func generateHeaders() -> HTTPHeaders {
        var headers = ["Authorization" : UIApplication.apiToken]
        headers["Content-Type"] = "application/json"
        return HTTPHeaders(headers)
    }
    
    private func handleBadResponse(with error: CustomError?) {
        switch error {
        case .badResponse:
            viewState = .error(.badResponse)
        case .statusCode(let httpCode):
            if httpCode == 401 {
                viewState = .error(.loginError)
            } else {
                viewState = .error(.serviceError)
            }
        case .some(.searchTextMissing):
            viewState = .error(.searchTextMissing)
        default:
            viewState = .error(.serviceError)
        }
    }
}
