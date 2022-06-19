//
//  HomeViewController.swift
//  iHotel
//
//  Created by admin on 05/07/2022.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var newReviewBtn: UIBarButtonItem!
    
    var data = [Review]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action:#selector(refresh) , for: .valueChanged)
        
        reloadData()
        Model.instance.notificationReviewsList.observe {
            self.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadData()
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getAllUsers() { users in
            Model.instance.getAllReviews { reviews in
                self.data = reviews
                self.reviewsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReviewDetailsViewController {
            destination.reviewObejct = data[(reviewsTableView.indexPathForSelectedRow?.row)!]
            reviewsTableView.deselectRow(at: reviewsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
    
extension HomeViewController: UITableViewDataSource {
    /* Delegate protocol */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "reviewListRow", for: indexPath) as! ReviewsTableViewCell
        
        let review = data[indexPath.row]
        cell.hotelTitle.text = review.hotelName
        cell.genre.text = review.genre
        cell.posterImage.kf.setImage(with: URL(string: review.imageUrl!),placeholder: UIImage(named: "Default Avatar"))
        cell.ratingStars.rating = Double(review.rating)
        cell.ratingStars.settings.updateOnTouch = false
        
        if let user = Model.instance.getUser(byId: review.userId!) {
            cell.userName.text = user.fullName
            cell.userImage.kf.setImage(with: URL(string: user.imageUrl!), placeholder: UIImage(named: "user_avatar"))
            cell.userImage.contentMode = .scaleAspectFill
            cell.userImage.layer.masksToBounds = false
            cell.userImage.layer.cornerRadius = cell.userImage.frame.width / 2
            cell.userImage.clipsToBounds = true
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    /* Table view delegate */

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReviewDetails", sender: self)
    }

}
