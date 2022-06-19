//
//  ReviewDetailsViewController.swift
//  iHotel
//
//  Created by admin on 21/07/2022.
//

import UIKit
import Kingfisher
import Cosmos

class ReviewDetailsViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var hotelTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var ratingStars: CosmosView!
    
    var reviewObejct: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Model.instance.getUser(byId: reviewObejct!.userId!) {
            userName.text = user.fullName
            userImage.kf.setImage(with: URL(string: user.imageUrl!),placeholder: UIImage(named: "user_avatar"))
            userImage.contentMode = .scaleAspectFill
            userImage.layer.masksToBounds = false
            userImage.layer.cornerRadius = userImage.frame.width / 2
            userImage.clipsToBounds = true
        }
        hotelTitle.text = reviewObejct!.hotelName
        genre.text = reviewObejct!.genre
        posterImage.kf.setImage(with: URL(string: reviewObejct!.imageUrl!),placeholder: UIImage(named: "Default Avatar"))
        review.text = reviewObejct!.review
        ratingStars.rating = Double(reviewObejct!.rating)
        ratingStars.settings.updateOnTouch = false

        review!.layer.borderWidth = 0.5
        review!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        review!.layer.cornerRadius = 5
        review!.clipsToBounds = true
        
        review.isEditable = false
    }
}
