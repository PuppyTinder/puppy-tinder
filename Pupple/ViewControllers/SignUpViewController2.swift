//
//  SignUpViewController2.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Parse

class SignUpViewController2: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var vaccinatedTextField: UITextField!
    @IBOutlet weak var neuteredTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initalizeUI() {
        self.nameTextField.delegate = self
        self.genderTextField.delegate = self
        self.breedTextField.delegate = self
        self.sizeTextField.delegate = self
        self.vaccinatedTextField.delegate = self
        self.neuteredTextField.delegate = self
        
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
