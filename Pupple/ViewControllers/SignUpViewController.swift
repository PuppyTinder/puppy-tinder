//
//  SignUpViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/5/22.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    // Go to page 2 of the sign up form and preserve the values from the first page
    @IBAction func goToNextPage(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let birthday = birthdayTextField.text!
        let phone = mobileNumberTextField.text!
        
        if(username.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty || birthday.isEmpty || phone.isEmpty )
        {
            showWarning()
        }
        else
        {
            self.performSegue(withIdentifier: "signUpPage2Segue", sender: nil)
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Date of Birth TextField Input Functions
    func createDateKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
        
        //to only show dates
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        //format the date string
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        
        birthdayTextField.text = dateFormat.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func initializeUI() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.firstnameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.birthdayTextField.delegate = self
        self.mobileNumberTextField.delegate = self
        
        createDateKeyboard()
        self.usernameTextField.becomeFirstResponder()
    }
    
    // Missing text field information
    func showWarning() {
        let alertController: UIAlertController = UIAlertController(title: "Error!", message: "Please fill in every field.", preferredStyle: .alert)
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in NSLog("Alert dismissed")}
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
            
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
