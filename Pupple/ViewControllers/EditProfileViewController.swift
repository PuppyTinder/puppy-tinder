//
//  EditProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/25/22.
//

import UIKit
import Parse
import AlamofireImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    
   
    
    @IBOutlet weak var dogNameTextField: UITextField!
    
    @IBOutlet weak var dogSizeTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var fixedTextField: UITextField!
    
    @IBOutlet weak var vaccinatedTextField: UITextField!
    
    @IBOutlet weak var aboutTextVIew: UITextView!
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    var vaccinatedPickerView = UIPickerView()
    var fixedPickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    
    let choices = ["", "Yes", "No"]
    let sizes = ["", "Small", "Medium", "Large"]
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UserProfileViewController
        let user = PFUser.current()!
        var dogArray = [PFObject]()
        let query = PFQuery(className: "Dog")
        query.whereKey("ownerid", equalTo: user)
        query.findObjectsInBackground { dogs, error in
            dogArray = dogs!
            
            for dog in dogArray
            {
                let dogName = self.dogNameTextField.text
                let dogSize = self.dogSizeTextField.text
                let dogAge = self.ageTextField.text!
                let dogAgeNum = Int(dogAge) ?? 0
                let fixed = self.fixedTextField.text
                let vaccinated = self.vaccinatedTextField.text
                let aboutDog = self.aboutTextVIew.text
                
                if(dogName != "")
                {
                    dog["name"] = dogName
                    destVC.dogNameLabel.text = dogName
                }
                
                        
                if(dogSize != "")
                {
                    dog["size"] = dogSize
                    destVC.dogSizeLabel.text = dogSize
                }
                        
                if(dogAge != "")
                {
                    dog["age"] = dogAgeNum
                    let dogAgeString = String(dogAgeNum)
                    destVC.dogAgeLabel.text = dogAgeString + " years old"
                }
                        
                if(fixed == "Yes")
                {
                    dog["fixed"] = true
                    destVC.fixedLabel.text = "Yes"
                }
                else if (fixed == "No")
                {
                    dog["fixed"] = false
                    destVC.fixedLabel.text = "No"
                }
                        
                if(vaccinated == "Yes")
                {
                    dog["vaccinated"] = true
                    destVC.vaccinatedLabel.text = "Yes"
                }
                else if(vaccinated == "No")
                {
                    dog["vaccinated"] = false
                    destVC.vaccinatedLabel.text = "No"
                }
            
                        
                if(aboutDog != "")
                {
                    dog["about"] = aboutDog
                    destVC.dogAboutLabel.text = aboutDog
                }
                
                let imageData = self.dogImageView.image!.pngData()
                let file = PFFileObject(name: "dog.png", data: imageData!)
                dog["dog_photo"] = file
                destVC.dogImageView.image = UIImage(data: imageData!)
                
                dog.saveInBackground { success, error in
                    if success != nil
                    {
                        print("saved")
                    }
                }
            
            }
            }
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {}
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.layer.cornerRadius = 50
          
        loadUserDetails()
        dogNameTextField.delegate = self
        vaccinatedPickerView.delegate = self
        fixedPickerView.delegate = self
        vaccinatedPickerView.dataSource = self
        fixedPickerView.dataSource = self
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        aboutTextVIew.delegate = self
        vaccinatedPickerView.tag = 1
        fixedPickerView.tag = 2
        sizePickerView.tag = 3
        
        vaccinatedTextField.inputView = vaccinatedPickerView
        fixedTextField.inputView = fixedPickerView
        dogSizeTextField.inputView = sizePickerView
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        aboutTextVIew.layer.borderWidth = 0.5
        aboutTextVIew.layer.cornerRadius = 5
        aboutTextVIew.layer.borderColor = borderColor.cgColor
        
        ageTextField.inputAccessoryView = toolBar()
        
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    func loadUserDetails(){
        
        let user = PFUser.current()!
        var dogArray = [PFObject]()
        let query = PFQuery(className: "Dog")
        query.whereKey("ownerid", equalTo: user)
        query.findObjectsInBackground { dogs, error in
            dogArray = dogs!
            
            for dog in dogArray
            {
                let dogImageFile = dog["dog_photo"] as! PFFileObject
                let dogUrlString = dogImageFile.url!
                let dogUrl = URL(string: dogUrlString)
                self.dogImageView.af.setImage(withURL: dogUrl!)
            }
        
        }
    }
    
    
    @IBAction func onCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 141, height: 133)
        let scaledImage = image.af.imageScaled(to: size)
        dogImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 || pickerView.tag == 2
        {
            return choices.count
        }
        else if pickerView.tag == 3
        {
            return sizes.count
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 || pickerView.tag == 2
        {
            return choices[row]
        }
        else if pickerView.tag == 3
        {
            return sizes[row]
        }
        else
        {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            vaccinatedTextField.text = choices[row]
            vaccinatedTextField.resignFirstResponder()
        }
        else if pickerView.tag == 2{
            fixedTextField.text = choices[row]
            fixedTextField.resignFirstResponder()
        }
        else if pickerView.tag == 3
        {
            dogSizeTextField.text = sizes[row]
            dogSizeTextField.resignFirstResponder()
        }
    }
    
    @objc func adjustInputView(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification && dogNameTextField.isEditing == false && dogSizeTextField.isEditing == false
        {
            self.view.frame.origin.y = 0 // reset
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            self.view.frame.origin.y -= adjustmentHeight
        }
        else
        {
            self.view.frame.origin.y = 0
        }
    }
    
    // Remove keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
    }
}
