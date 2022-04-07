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
        dateFormat.dateStyle = .medium
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
