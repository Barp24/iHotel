//
//  MyReviewsTableViewCell.swift
//  iHotel
//
//  Created by admin on 18/07/2022.
//

import UIKit
import Cosmos

class MyReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var HotelNameText: UILabel!
    @IBOutlet weak var genreText: UILabel!
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
