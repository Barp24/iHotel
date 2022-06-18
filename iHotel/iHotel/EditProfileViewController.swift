//
//  EditProfileViewController.swift
//  iHotel
//
//  Created by admin on 20/07/2022.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var user: User?
    var selectedImage: UIImage?
    
    @IBAction func saveClicked(_ sender: Any) {
        if (isFormValid()) {
            loading.startAnimating()
            
            user?.fullName = fullNameText.text!
            
            if selectedImage != nil {
                Model.instance.saveProfileImage(image: selectedImage!, userId: (user?.id)!) { imageUrl in
                    if (imageUrl != "") {
                        self.user?.imageUrl = imageUrl
                        self.saveUser()
                    }
                    else {
                        self.displayAlert(message: "Failed to update user")
                        self.loading.stopAnimating()
                    }
                }
            }
            else {
                saveUser()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set profile image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        self.user = Model.instance.getUser(byId: Auth.auth().currentUser!.uid)
        fullNameText.text = user?.fullName
        emailText.text = Auth.auth().currentUser!.email
        profileImage.kf.setImage(with: URL(string: (user?.imageUrl)!), placeholder: UIImage(named: "user_avatar"))
        loading.stopAnimating()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        }
        else {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImage.image = selectedImage
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        if (self.fullNameText.text?.isEmpty ?? true){
            isValid = false
            displayAlert(message: "Please fill all fields")
        }
        
        return isValid
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveUser() {
        Model.instance.updateUser(user: user!) { isUpdated in
            if (isUpdated) {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.displayAlert(message: "Failed to update user")
                self.loading.stopAnimating()
            }
        }
    }
}
