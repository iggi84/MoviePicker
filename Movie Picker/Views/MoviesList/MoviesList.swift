//
//  ViewController.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 11.3.24..
//

import UIKit

class MoviesList: UIViewController {

    // MARK: - Oulets
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptySeacrhView: UIView!
    
    // MARK: - Properties
    
    private let viewModel = MovieListViewModel()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configureUI()
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        viewModel.searchMovie(for: searchTextfield.text ?? "")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.addSubview(refreshControl)
    }
    
    private func startActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    @objc private func didPullToRefresh(_ sender: AnyObject) {
        viewModel.refreshMovies(for: searchTextfield.text ?? "")
    }
    
    private func toggleEmptyView() {
        if viewModel.numberOfMovies == 0 {
            emptySeacrhView.isHidden = false
        } else {
            emptySeacrhView.isHidden = true
        }
    }
    
    private func showAlert(for error: DisplayError) {
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - ViewStateDelegate

extension MoviesList: ViewStateDelegate {
    
    func didUpdate(with viewState: ViewState) {
        
        switch viewState {
        case .emptyList:
            hideActivityIndicator()
        case .loadingData:
            startActivityIndicator()
        case .idle:
            hideActivityIndicator()
        case .success:
            hideActivityIndicator()
            tableView.reloadData()
        case .error( let error):
            hideActivityIndicator()
            showAlert(for: error)
        }
        toggleEmptyView()
    }
}

// MARK: -  UItableView Delegate and Datasource

extension MoviesList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.movie = viewModel.getMovie(for: indexPath)
        return cell
    }
}
