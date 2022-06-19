//
//  MyReviewsViewController.swift
//  iHotel
//
//  Created by admin on 18/07/2022.
//

import UIKit
import Kingfisher
import Firebase

class MyReviewsViewController: UIViewController {
    @IBOutlet weak var myReviewsTableView: UITableView!
    var data = [Review]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myReviewsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action:#selector(refresh) , for: .valueChanged)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longPressGesture)
        
        reloadData()
        Model.instance.notificationReviewsList.observe {
            self.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadData()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.myReviewsTableView)
            if let indexPath = myReviewsTableView.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
                    self.performSegue(withIdentifier: "toEditReviewSegue", sender: indexPath.row)
                })
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.displayDeleteAlert(review: self.data[indexPath.row])
                })
                present(alert, animated: true)
            }
        }
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getReviews(byUserId: Auth.auth().currentUser!.uid) { reviews in
            self.data = reviews
            self.myReviewsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayDeleteAlert(review: Review) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this review?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            Model.instance.delete(review: review) { isRemoved in
                if isRemoved {
                    self.reloadData()
                }
                else {
                    self.displayAlert(message: "Error deleting review")
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditReviewSegue" {
            let editVC = segue.destination as! EditReviewViewController
            editVC.reviewId = data[sender as! Int].id!
        }
    }
}

extension MyReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myReviewsTableView.dequeueReusableCell(withIdentifier: "myReviewListRow", for: indexPath) as! MyReviewsTableViewCell
        
        let review = data[indexPath.row]
        cell.HotelNameText.text = review.hotelName
        cell.genreText.text = review.genre
        cell.ratingStars.rating = Double(review.rating)
        cell.ratingStars.settings.updateOnTouch = false
        cell.hotelImage.kf.setImage(with: URL(string: (review.imageUrl)!), placeholder: UIImage(named: "Default Avatar"))
        
        return cell
    }
}

extension MyReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
