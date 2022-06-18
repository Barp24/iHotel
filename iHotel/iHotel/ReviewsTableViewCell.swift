//
//  ReviewsTableViewCell.swift
//  iHotel
//
//  Created by admin on 09/07/2022.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var hotelTitle: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
