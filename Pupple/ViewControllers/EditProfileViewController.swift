//
//  EditProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/25/22.
//

import UIKit
import Parse
import AlamofireImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
   
    
    @IBOutlet weak var dogNameTextField: UITextField!
    
    @IBOutlet weak var dogSizeTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var fixedTextField: UITextField!
    
    @IBOutlet weak var vaccinatedTextField: UITextField!
    
    @IBOutlet weak var aboutTextVIew: UITextView!
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    var vaccinatedPickerView = UIPickerView()
    var fixedPickerView = UIPickerView()
    
    let choices = ["", "Yes", "No"]
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
     
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
                let dogAge = self.ageTextField.text
                let fixed = self.fixedTextField.text
                let vaccinated = self.vaccinatedTextField.text
                let aboutDog = self.aboutTextVIew.text
                
                if(dogName != "")
                {
                    dog["name"] = dogName
                }
                
                        
                if(dogSize != "")
                {
                    dog["size"] = dogSize
                }
                        
                if(dogAge != "")
                {
                    dog["age"] = dogAge
                }
                        
                if(fixed == "Yes")
                {
                    dog["fixed"] = true
                }
                else
                {
                    dog["fixed"] = false
                }
                        
                if(vaccinated == "Yes")
                {
                    dog["vaccinated"] = true
                }
                else
                {
                    dog["vaccinated"] = false
                }
            
                        
                if(aboutDog != "")
                {
                    dog["about"] = aboutDog
                }
                
                dog.saveInBackground { success, error in
                    if success != nil
                    {
                        print("saved")
                        self.dismiss(animated: true)
                    }
                }
            
            }
            }
        
        }
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.layer.cornerRadius = 50
          
        loadUserDetails()
        
        vaccinatedPickerView.delegate = self
        fixedPickerView.delegate = self
        vaccinatedPickerView.dataSource = self
        fixedPickerView.dataSource = self
        
        vaccinatedPickerView.tag = 1
        fixedPickerView.tag = 2
        
        vaccinatedTextField.inputView = vaccinatedPickerView
        fixedTextField.inputView = fixedPickerView
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        aboutTextVIew.layer.borderWidth = 0.5
        aboutTextVIew.layer.cornerRadius = 5
        aboutTextVIew.layer.borderColor = borderColor.cgColor
           // Do any additional setup after loading the view.
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
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
    }


}
