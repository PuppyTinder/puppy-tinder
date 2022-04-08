//
//  SignUpViewController2.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Parse

class SignUpViewController2: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var vaccinatedTextField: UITextField!
    @IBOutlet weak var neuteredTextField: UITextField!
    
    // Array of options for picker views
    let genders = ["","Male", "Female"]
    let choices = ["", "Yes", "No"]
    let sizes = ["", "Small", "Medium", "Large"]
    
    var genderPickerView = UIPickerView()
    var vaccinatedPickerView = UIPickerView()
    var neuteredPickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    
    let defaults = UserDefaults.standard
    // Keys to access the values passed from page one
    let USERNAME_KEY = "Username Key"
    let PASSWORD_KEY = "Password Key"
    let FIRSTNAME_KEY = "Firstname Key"
    let LASTNAME_KEY = "Lastname Key"
    let BIRTHDAY_KEY = "Birthday Key"
    let MOBILE_NUMBER_KEY = "Mobile Number Key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let user = PFUser() // Get the current user object
        let dog = PFObject(className: "Dog") // Get the current dog object
        
        let username = defaults.string(forKey: USERNAME_KEY)
        let password = defaults.string(forKey: PASSWORD_KEY)
        let firstname = defaults.string(forKey: FIRSTNAME_KEY)
        let lastname = defaults.string(forKey: LASTNAME_KEY)
        let birthday = defaults.string(forKey: BIRTHDAY_KEY)
        let phone = defaults.string(forKey: MOBILE_NUMBER_KEY)
        
        let dog_name = nameTextField.text!
        let dog_gender = genderTextField.text!
        let breed = genderTextField.text!
        let size = sizeTextField.text!
        var vaccinated : Bool?
        var neutered : Bool?
        
        if vaccinatedTextField.text == "Yes"
        {
            vaccinated = true
        }
        else if vaccinatedTextField.text == "No"
        {
            vaccinated = false
        }
        
        if neuteredTextField.text == "Yes"
        {
            neutered = true
        }
        else if neuteredTextField.text == "No"
        {
            neutered = false
        }
        
        // Sign up the user
        user.username = username
        user.password = password
        user["firstname"] = firstname
        user["lastname"] = lastname
        user["birthday"] = birthday
        user["phone_number"] = phone
        
        user.signUpInBackground { (success, error) in
            if (success)
            {
    
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        // Sign up the dog
        dog["name"] = dog_name
        dog["gender"] = dog_gender
        dog["breed"] = breed
        dog["size"] = size
        dog["vaccinated"] = vaccinated
        dog["fixed"] = neutered
        //dog["ownerid"] = user
        //dog["ownerid"] = PFUser.current()!
        dog.setObject(user, forKey: "ownerid")
        dog.saveInBackground { success, error in
            if (success)
            {
                self.signUpSuccess()
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.signUpFailure()
            }
        }
        
        resetDefaults()
    }
    
    func resetDefaults()
    {
        defaults.removeObject(forKey: USERNAME_KEY)
        defaults.removeObject(forKey: PASSWORD_KEY)
        defaults.removeObject(forKey: FIRSTNAME_KEY)
        defaults.removeObject(forKey: LASTNAME_KEY)
        defaults.removeObject(forKey: BIRTHDAY_KEY)
        defaults.removeObject(forKey: MOBILE_NUMBER_KEY)
        nameTextField.text = ""
        genderTextField.text = ""
        breedTextField.text = ""
        sizeTextField.text = ""
        vaccinatedTextField.text = ""
        neuteredTextField.text = ""
    }
    
    func signUpSuccess() {
        let alertController: UIAlertController = UIAlertController(title: "Hurray", message: "Successfully signed up!", preferredStyle: .alert)
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in NSLog("Alert dismissed")}
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
            
        }
    
    func signUpFailure() {
        let alertController: UIAlertController = UIAlertController(title: "Error", message: "Failed to sign up!", preferredStyle: .alert)
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in NSLog("Alert dismissed")}
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
            
        }
    
    /* -----  PickerView Functions ----- */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
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
            return genders.count
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
            return genders[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1
        {
            vaccinatedTextField.text = choices[row]
            vaccinatedTextField.resignFirstResponder()
        }
        else if pickerView.tag == 2
        {
            neuteredTextField.text = choices[row]
            neuteredTextField.resignFirstResponder()
        }
        else if pickerView.tag == 3
        {
            sizeTextField.text = sizes[row]
            sizeTextField.resignFirstResponder()
        }
        else
        {
            genderTextField.text = genders[row]
            genderTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initializeUI() {
        nameTextField.delegate = self
        genderTextField.delegate = self
        breedTextField.delegate = self
        sizeTextField.delegate = self
        vaccinatedTextField.delegate = self
        neuteredTextField.delegate = self
        
        vaccinatedPickerView.delegate = self
        vaccinatedPickerView.dataSource = self
        vaccinatedPickerView.tag = 1
        neuteredPickerView.delegate = self
        neuteredPickerView.dataSource = self
        neuteredPickerView.tag = 2
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        sizePickerView.tag = 3
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 4
        sizeTextField.inputView = sizePickerView
        vaccinatedTextField.inputView = vaccinatedPickerView
        neuteredTextField.inputView = neuteredPickerView
        genderTextField.inputView = genderPickerView
        
        self.nameTextField.becomeFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
