//
//  MovieDetails.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 11.3.24..
//

import UIKit
import Kingfisher

class MovieDetails: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: MovieDetailsViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        if let movie = viewModel?.movie {
            let placeholder = UIImage(named: "MoviePlaceholder")
            movieImage.kf.setImage(with: Endpoint.image.imageURL(for: movie.posterPath ?? "", imageSize: .original), placeholder: placeholder)
            titleLabel.text = movie.title
            descriptionLabel.text = movie.displayDate
            ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
            synopsisLabel.text = movie.overview
        }
    }
}
