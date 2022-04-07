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
    let choices = ["", "Yes", "No"]
    let sizes = ["", "Small", "Medium", "Large"]
    
    var vaccinatedPickerView = UIPickerView()
    var neuteredPickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
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
        else
        {
            return sizes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) || pickerView.tag == 2
        {
            return choices[row]
        }
        else
        {
            return sizes[row]
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
        else
        {
            sizeTextField.text = sizes[row]
            sizeTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initalizeUI() {
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
        sizeTextField.inputView = sizePickerView
        vaccinatedTextField.inputView = vaccinatedPickerView
        neuteredTextField.inputView = neuteredPickerView
        
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
