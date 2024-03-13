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
}

// MARK: - Network Service

extension MovieListViewModel {
    
    func searchMovie(for movieName: String) {
        viewState = .loadingData
        
        let searchParams = [
            "query" : movieName,
            "page" : currentPage
        ] as [String : Any]
        Network.mainService.getRequest(to: Endpoint.search.url, parameters: searchParams, headers: generateHeaders(), expectedReturnType: SearchResponse.self) { [weak self] response in
            do {
                if let searchResponse = try response() {
                    self?.currentPage = (searchResponse.page ?? 0) + 1
                    self?.searchedMovies.append(contentsOf: searchResponse.results ?? [])
                    self?.viewState = .success
                }
            } catch {
                self?.handleBadResponse(with: error as? CustomError)
            }
        }
    }
    
    func generateHeaders() -> HTTPHeaders {
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
