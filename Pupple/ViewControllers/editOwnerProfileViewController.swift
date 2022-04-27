//
//  editOwnerProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/27/22.
//

import UIKit
import Parse
import AlamofireImage

class editOwnerProfileViewController: UIViewController {
    
    
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelButtonTapped(_ sender: AnyObject) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func DoneButtonTapped(_ sender: AnyObject){
        
        let name = firstNameTextField.text!
        let lastName = lastNameTextField.text
        let gender = genderTextField.text
        let userEducation = educationTextField.text!
        let insta = instaTextField.text
        let snap = snapTextField.text
        let occupation = occupationTextField.text
        let aboutMe = aboutMeTextField.text
        let location = locationTextField.text
     
        let user = PFUser.current()!
        
        if(name != "")
        {
            user["firstname"] = name
        }
       
        if(userEducation != "")
        {
            user["education"] = userEducation
        }
        
        if(lastName != "")
        {
            user["lastname"] = lastName
        }
        
        if(gender != "")
        {
            user["gender"] = userEducation
        }
        
        if(insta != "")
        {
            user["instagram"] = insta
        }
        
        if(snap != "")
        {
            user["snapchat"] = snap
        }
        
        if(occupation != "")
        {
            user["occupation"] = occupation
        }
        
        if(aboutMe != "")
        {
            user["about"] = aboutMe 
        }
        
        if(location != "")
        {
            user["location"] = location
        }
        
        
        user.saveInBackground { success, error in
            if success != nil
            {
                print("saved")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    } 
    
    func loadUserDetails(){
        let user = PFUser.current()!
        let userImageFile = user["user_photo"] as! PFFileObject
        let fileUrlString = userImageFile.url!
        let fileUrl = URL(string: fileUrlString)
        profileImageView.af.setImage(withURL: fileUrl!)

    }
}
