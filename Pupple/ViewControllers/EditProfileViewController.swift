//
//  EditProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/25/22.
//

import UIKit
import Parse
import AlamofireImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate {
    
   
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let name = firstNameTextField.text!
        let userEducation = educationTextField.text!
     
        let user = PFUser.current()!
        
        if(name != "")
        {
            user["firstname"] = name
        }
       
        if(userEducation != "")
        {
            user["education"] = userEducation
        }
        
        user.saveInBackground { success, error in
            if success != nil
            {
                print("saved")
                self.dismiss(animated: true, completion: nil)
            }
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
          
        loadUserDetails()
           
           // Do any additional setup after loading the view.
       }
    
    func loadUserDetails(){
        let user = PFUser.current()!
        let userImageFile = user["user_photo"] as! PFFileObject
        let fileUrlString = userImageFile.url!
        let fileUrl = URL(string: fileUrlString)
        profileImageView.af.setImage(withURL: fileUrl!)
            
        }
   



}
