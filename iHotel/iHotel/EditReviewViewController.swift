//
//  EditReviewViewController.swift
//  iHotel
//
//  Created by admin on 19/07/2022.
//

import UIKit
import Kingfisher
import Cosmos

class EditReviewViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelNameText: UITextField!
    @IBOutlet weak var releaseYearText: UITextField!
    @IBOutlet weak var genreText: UITextField!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var ReviewText: UITextView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var reviewId: String = ""
    var review: Review?
    var selectedImage: UIImage?
    var selectedYear: Int64 = 0
    var selectedGenre: String?
    let YEAR_TAG = 0
    let GENRE_TAG = 1
    var yearsData = [Int]()
    var genreData = [String]()
    
    @IBAction func saveClicked(_ sender: Any) {
        if (isFormValid()){
            loading.startAnimating()
            
            review?.hotelName = hotelNameText.text!
            review?.releaseYear = selectedYear
            review?.genre = selectedGenre
            review?.rating = Int64(ratingStars.rating)
            review?.review = ReviewText.text!
            
            if selectedImage != nil {
                Model.instance.saveReviewImage(image: selectedImage!, reviewId: (review?.id)!) { imageUrl in
                    if imageUrl != "" {
                        self.review?.imageUrl = imageUrl
                        self.saveReview()
                    }
                    else {
                        self.displayAlert(message: "Failed to update review")
                        self.loading.stopAnimating()
                    }
                }
            }
            else {
                saveReview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearsData = Model.instance.yearsData
        genreData = Model.instance.genreData
        
        // Set hotel image clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        hotelImage.isUserInteractionEnabled = true
        hotelImage.addGestureRecognizer(tapGestureRecognizer)
        
        ReviewText!.layer.borderWidth = 0.5
        ReviewText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        ReviewText!.layer.cornerRadius = 5
        ReviewText!.clipsToBounds = true
        
        ratingStars.settings.fillMode = .full
        releaseYearText.delegate = self
        genreText.delegate = self
        
        if let selectedReview = Model.instance.getReview(byId: reviewId) {
            review = selectedReview
            selectedYear = review!.releaseYear
            selectedGenre = review?.genre
            hotelNameText.text = review?.hotelName!
            releaseYearText.text = String(review!.releaseYear)
            genreText.text = review?.genre
            ratingStars.rating = Double(review!.rating)
            ReviewText.text = review?.review
            hotelImage.kf.setImage(with: URL(string: (review?.imageUrl)!), placeholder: UIImage(named: "Default Avatar"))
            createPickerViews()
            loading.stopAnimating()
        }
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
        self.hotelImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFormValid() -> Bool {
        var isValid = true
        
        if ((self.hotelNameText.text?.isEmpty ?? true) || (ReviewText.text?.isEmpty ?? true)){
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
    
    func saveReview() {
        Model.instance.update(review: review!) { isUpdated in
            if isUpdated {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.displayAlert(message: "Failed to update review")
                self.loading.stopAnimating()
            }
        }
    }
}

extension EditReviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == YEAR_TAG {
            return yearsData.count
        }
        else {
            return genreData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == YEAR_TAG {
            return String(yearsData[row])
        }
        else {
            return genreData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == YEAR_TAG {
            selectedYear = Int64(yearsData[row])
            releaseYearText.text = String(selectedYear)
        }
        else {
            selectedGenre = genreData[row]
            genreText.text = selectedGenre
        }
    }
    
    func createPickerViews() {
        let yearPickerView = UIPickerView()
        yearPickerView.delegate = self
        yearPickerView.tag = YEAR_TAG
        yearPickerView.selectRow(yearsData.firstIndex(of: Int(review!.releaseYear))!, inComponent: 0, animated: false)
        
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genrePickerView.tag = GENRE_TAG
        genrePickerView.selectRow(genreData.firstIndex(of: (review?.genre)!)!, inComponent: 0, animated: false)
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        releaseYearText.inputView = yearPickerView
        releaseYearText.inputAccessoryView = toolBar
        
        genreText.inputView = genrePickerView
        genreText.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
}

extension EditReviewViewController: UITextFieldDelegate {
    // To prevent input by text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
