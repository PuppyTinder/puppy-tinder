//
//  editOwnerProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/27/22.
//

import UIKit
import Parse
import AlamofireImage

class editOwnerProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var educationTextField: UITextField!
    
    @IBOutlet weak var instaTextField: UITextField!
    
    @IBOutlet weak var snapTextField: UITextField!
    
    @IBOutlet weak var occupationTextField: UITextField!
    
    @IBOutlet weak var aboutMeTextField: UITextView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 50
        loadUserDetails()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        aboutMeTextField.layer.borderWidth = 0.5
        aboutMeTextField.layer.borderColor = borderColor.cgColor
        aboutMeTextField.layer.cornerRadius = 5
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTextField.delegate = self
        educationTextField.delegate = self
        instaTextField.delegate = self
        snapTextField.delegate = self
        occupationTextField.delegate = self
        aboutMeTextField.delegate = self
        locationTextField.delegate = self
        
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UserProfileViewController
        
        let name = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let gender = genderTextField.text!
        let userEducation = educationTextField.text!
        let insta = instaTextField.text!
        let snap = snapTextField.text!
        let occupation = occupationTextField.text!
        let aboutMe = aboutMeTextField.text!
        let location = locationTextField.text!
     
        let user = PFUser.current()!
        
        if(name != "")
        {
            user["firstname"] = name
            let lastname = user["lastname"] as! String
            destVC.ownerNameLabel.text = name + " " + lastname
        }
       
        if(userEducation != "")
        {
            user["education"] = userEducation
            destVC.ownerEducationLabel.text = userEducation
        }
        
        if(lastName != "")
        {
            user["lastname"] = lastName
            let firstname = user["firstname"] as! String
            destVC.ownerNameLabel.text = firstname + " " + lastName
        }
        
        if(gender != "")
        {
            user["gender"] = gender
            destVC.ownerGenderLabel.text = gender
        }
        
        if(insta != "")
        {
            user["instagram"] = insta
            destVC.ownerInstagramButton.setTitle(insta, for: .normal)
        }
        
        if(snap != "")
        {
            user["snapchat"] = snap
            destVC.ownerSnapchatButton.setTitle(snap, for: .normal)
        }
        
        if(occupation != "")
        {
            user["occupation"] = occupation
            destVC.ownerOccupationLabel.text = occupation
        }
        
        if(aboutMe != "")
        {
            user["about"] = aboutMe
            destVC.aboutLabel.text = aboutMe
        }
        
        if(location != "")
        {
            user["location"] = location
            destVC.dogLocationLabel.text = location
        }
        
        
        user.saveInBackground { success, error in
            if success != nil
            {
                print("saved")
            }
        }
    }
    
    @IBAction func CancelButtonTapped(_ sender: AnyObject) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func DoneButtonTapped(_ sender: AnyObject){}
    
    func loadUserDetails(){
        let user = PFUser.current()!
        let userImageFile = user["user_photo"] as! PFFileObject
        let fileUrlString = userImageFile.url!
        let fileUrl = URL(string: fileUrlString)
        profileImageView.af.setImage(withURL: fileUrl!)

    }
    
    @objc func adjustInputView(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification && firstNameTextField.isEditing == false && lastNameTextField.isEditing == false && genderTextField.isEditing == false
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
