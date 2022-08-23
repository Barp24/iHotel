//
//  RegisterViewController.swift
//  iHotel
//
//  Created by admin on 03/07/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var selectedImage: UIImage?
    
    @IBAction func registerClicked(_ sender: Any) {
        if (isFormValid()) {
            loading.startAnimating()
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
                if error != nil {
                    print(error)
                    self.loading.stopAnimating()
//                    if [AuthErrorCode.networkError, AuthErrorCode.invalidEmail, AuthErrorCode.emailAlreadyInUse].contains(AuthErrorCode(rawValue: error._code)){
//                        self.displayAlert(message: error.localizedDescription)
//                    }
//                    else {
                        self.displayAlert(message: "An Error occured. Please try again later")
//                    }
                }
                else {
                    // Save image
                    Model.instance.saveProfileImage(image: self.selectedImage!, userId: Auth.auth().currentUser!.uid) { (url) in
                        if url != "" {
                            // Save user
                            let user = User.create(id: Auth.auth().currentUser!.uid, fullName: self.fullNameText.text!, imageUrl: url, lastUpdated: 0)
                            Model.instance.addUser(user: user) { (isAdded) in
                                if (isAdded) {
                                    self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
                                }
                                else {
                                    self.loading.stopAnimating()
                                    self.displayAlert(message: "There was an error while saving your user, please try again later")
                                }
                            }
                        }
                        else {
                            self.loading.stopAnimating()
                            self.displayAlert(message: "There was an error while saving your user, please try again later")
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.stopAnimating()

        // Set profile image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
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
        
        checks: if selectedImage == nil {
            isValid = false
            displayAlert(message: "Please choose a profile picture")
            break checks
        }
        else if ((self.fullNameText.text?.isEmpty ?? true) || (emailText.text?.isEmpty ?? true) || (passwordText.text?.isEmpty ?? true)) {
            isValid = false
            displayAlert(message: "Please fill all fields")
            break checks
        }
        else if (passwordText.text!.count < 6) {
            isValid = false
            displayAlert(message: "Password must be at least 6 characters")
            break checks
        }
        
        return isValid
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
