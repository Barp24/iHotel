//
//  ProfileViewController.swift
//  iHotel
//
//  Created by admin on 18/07/2022.
//

import UIKit
import Firebase
import Kingfisher

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    var menuViewController: ProfileMenuTableViewController?
    
    @IBAction func logoutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch _ as NSError {
          displayAlert(message: "There was an error while saving your user, please try again later")
        }
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController = (self.children[0] as? ProfileMenuTableViewController)!
        menuViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Model.instance.getAllUsers { users in
            let user = Model.instance.getUser(byId: Auth.auth().currentUser!.uid)
            self.fullNameText.text = user?.fullName
            self.emailText.text = Auth.auth().currentUser!.email
            if(user?.imageUrl != nil) {
                self.profileImage.kf.setImage(with: URL(string: (user?.imageUrl)!), placeholder: UIImage(named: "user_avatar"))
            }
        }
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController:  ProfileTableViewControllerDelegate {
    func cellTapped(action: MenuAction) {
        switch action {
        case MenuAction.editName:
            self.performSegue(withIdentifier: "toEditProfileSegue", sender: self)
            print(action.rawValue)
            break
        case MenuAction.changePass:
            changePass()
            break
        case MenuAction.myReviews:
            self.performSegue(withIdentifier: "toMyReviewsSegue", sender: self)
            break
        }
    }
    
    func changePass() {
        let alert = UIAlertController(title: "Change Password", message: "You must fill all fields", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Current Password*"
        }
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "New Password*"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action:UIAlertAction) in
            if alert.textFields?[0].text! != "" && alert.textFields?[1].text! != "" {
                let user = Auth.auth().currentUser
                let cred = EmailAuthProvider.credential(withEmail: (user?.email)!, password: (alert.textFields?[0].text!)!)
                user?.reauthenticate(with: cred) { result, error in
                    if error != nil {
                        self.displayAlert(message: "Error changing password, please try again later")
                    } else {
                        user?.updatePassword(to: (alert.textFields?[1].text!)!) { error in
                            if error != nil {
                                self.displayAlert(message: "Error changing password, please try again later")
                            }
                        }
                    }
                }
            }
            else {
                self.displayAlert(message: "You must fill all fields")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
