//
//  MovieCell.swift
//  Movie Picker
//
//  Created by Igor  Vojinovic on 13.3.24..
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell, NibProtocol {

    // MARK: - Outlets
    
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Properties
    
    var movie: MovieResponse? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        movieInfoView.layer.cornerRadius = 8
        movieInfoView.layer.borderWidth = 1
        movieInfoView.layer .borderColor = UIColor.lightGray.cgColor
        movieImage.layer.cornerRadius = 8
        
        movieInfoView.layer.masksToBounds = false
        movieInfoView.layer.shadowColor = UIColor.black.cgColor
        movieInfoView.layer.shadowOpacity = 1.0
        movieInfoView.layer.shadowOffset = .zero
        movieInfoView.layer.shadowRadius = 1
        movieInfoView.layer.shouldRasterize = true
    }
    
    private func updateUI() {
        guard let movie else {
            return
        }
        let placeholder = UIImage(named: "MoviePlaceholder")
        movieImage.kf.setImage(with: Endpoint.image.imageURL(for: movie.posterPath ?? "", imageSize: .w154), placeholder: placeholder)
        titleLabel.text = movie.title
        descriptionLabel.text = movie.displayDate
        ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
    }
}
