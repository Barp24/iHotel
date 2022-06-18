//
//  ProfileMenuTableViewController.swift
//  iHotel
//
//  Created by admin on 18/07/2022.
//

import UIKit

enum MenuAction: String {
    case editName, changePass, myReviews
}

class ProfileMenuTableViewController: UITableViewController {
    weak var delegate : ProfileTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
        var action: MenuAction?
        
        // edit name, email
        if (indexPath.section == 0 && indexPath.row == 0) {
            action = MenuAction.editName
        }
        // change password
        else if (indexPath.section == 0 && indexPath.row == 1) {
            action = MenuAction.changePass
        }
        // my reviews
        else if (indexPath.section == 1 && indexPath.row == 0) {
            action = MenuAction.myReviews
        }
        
        if let delegate = delegate {
            delegate.cellTapped(action: action!)
            
        }
      }
}

protocol ProfileTableViewControllerDelegate : AnyObject {
    func cellTapped(action: MenuAction)
}
