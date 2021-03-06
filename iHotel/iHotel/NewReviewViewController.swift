//
//  NewReviewViewController.swift
//  iHotel
//
//  Created by admin on 13/07/2022.
//

import UIKit
import FirebaseAuth
import Cosmos

class NewReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var selectedImageVar: UIImage?
    var selectedCity: String?
    let CITY_TAG = 1
    var cityData = [String]()
    
    var data = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.stopAnimating()
        cityData = Model.instance.cities
        
        // Set hotel image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
        
        reviewText!.layer.borderWidth = 0.5
        reviewText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        reviewText!.layer.cornerRadius = 5
        reviewText!.clipsToBounds = true

        ratingStars.rating = 0
        
        cityText.delegate = self
        createPickerViews()
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
        selectedImageVar = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.selectedImage.image = selectedImageVar
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if (isFormValid()) {
            loading.startAnimating()
            
            let reviewId = Model.instance.generateReviewId()
            Model.instance.saveReviewImage(image: self.selectedImageVar!, reviewId: reviewId) { imageUrl in
                if imageUrl != "" {
                    let review = Review.createReview(id: reviewId, hotelName: self.hotelName.text!, city: self.cityText.text!, imageUrl: imageUrl, rating: Int64(self.ratingStars.rating), review: self.reviewText.text!, userId: Auth.auth().currentUser!.uid, lastUpdated: 0)
                    
                    Model.instance.add(review: review) { isAdded in
                        if isAdded {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.displayAlert(message: "Failed to create review")
                        }
                    }
                } else {
                    self.displayAlert(message: "Failed to create review")
                }
            }
        }
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        checks: if selectedImageVar == nil {
            isValid = false
            displayAlert(message: "Please choose an image for the hotel")
            break checks
        }
        else if ((self.hotelName.text?.isEmpty ?? true) || (cityText.text?.isEmpty ?? true) || (reviewText.text?.isEmpty ?? true)){
            isValid = false
            displayAlert(message: "Please fill all fields")
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

extension NewReviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == CITY_TAG {
            return cityData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == CITY_TAG {
            return cityData[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == CITY_TAG {
            selectedCity = cityData[row]
            cityText.text = selectedCity
        }
    }
    
    func createPickerViews() {
        let cityPickerView = UIPickerView()
        cityPickerView.delegate = self
        cityPickerView.tag = CITY_TAG
        cityPickerView.selectRow(0, inComponent: 0, animated: false)
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        cityText.inputView = cityPickerView
        cityText.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
}

extension NewReviewViewController : UITextFieldDelegate {
    // To prevent input by text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
