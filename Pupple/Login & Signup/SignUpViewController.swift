//
//  SignUpViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/5/22.
//

import UIKit
import Parse
import AlamofireImage

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let defaults = UserDefaults.standard // Used to store the currently entered user information and pass it on to the next segue
    
    // Keys to access the values passed in
    let USERNAME_KEY = "Username Key"
    let PASSWORD_KEY = "Password Key"
    let FIRSTNAME_KEY = "Firstname Key"
    let LASTNAME_KEY = "Lastname Key"
    let BIRTHDAY_KEY = "Birthday Key"
    let MOBILE_NUMBER_KEY = "Mobile Number Key"
    let LOCATION_KEY = "Location Key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
     
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
   /* ------ Functions to store user input ------ */
    
    // Will launch camera when image is selected
    @IBAction func onCameraButton(_ sender: Any) {
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
        userImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setUsername(_ sender: Any) {
        let username = usernameTextField.text!
        defaults.set(username, forKey: USERNAME_KEY)
    }
    
    @IBAction func setPassword(_ sender: Any) {
        let password = passwordTextField.text!
        defaults.set(password, forKey: PASSWORD_KEY)
    }
    
    @IBAction func setFirstName(_ sender: Any) {
        let firstname = firstnameTextField.text!
        defaults.set(firstname, forKey: FIRSTNAME_KEY)
    }
    
    @IBAction func setLastName(_ sender: Any) {
        let lastname = lastnameTextField.text!
        defaults.set(lastname, forKey: LASTNAME_KEY)
    }
    
    @IBAction func setDOB(_ sender: Any) {
        let birthday = birthdayTextField.text!
        defaults.set(birthday, forKey: BIRTHDAY_KEY)
    }
    
    @IBAction func setMobileNumber(_ sender: Any) {
        let phone = mobileNumberTextField.text!
        defaults.set(phone, forKey: MOBILE_NUMBER_KEY)
    }
    
    @IBAction func setLocation(_ sender: Any) {
        let location = locationTextField.text!
        defaults.set(location, forKey: LOCATION_KEY)
    }
    
    // Go to page 2 of the sign up form and preserve the values from the first page
    @IBAction func goToNextPage(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let birthday = birthdayTextField.text!
        let phone = mobileNumberTextField.text!
        let location = locationTextField.text!
        
        let user = PFUser()
        let imageData = userImageView.image!.pngData()
        let file = PFFileObject(name: "user.png", data: imageData!)
        
        user.username = username
        user.password = password
        user["firstname"] = firstname
        user["lastname"] = lastname
        user["birthday"] = birthday
        user["phone_number"] = phone
        user["location"] = location
        
        user.signUpInBackground { (success, error) in
            if (success)
            {
                user["user_photo"] = file
                user.saveInBackground()
                self.resetInput()
                self.performSegue(withIdentifier: "signUpPage2Segue", sender: nil)
            }
            else
            {
                self.showWarning()
            }
        }
    }
    
    func resetInput()
    {
        usernameTextField.text = ""
        passwordTextField.text = ""
        firstnameTextField.text = ""
        lastnameTextField.text = ""
        birthdayTextField.text = ""
        mobileNumberTextField.text = ""
        locationTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Date of Birth TextField Input Functions
    func createDateKeyboard() {
        birthdayTextField.inputView = datePicker
        
        //to only show dates
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func initializeUI() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.firstnameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.birthdayTextField.delegate = self
        self.mobileNumberTextField.delegate = self
        self.locationTextField.delegate = self
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width/2
        
        createDateKeyboard()
    }
    
    // Missing text field information
    func showWarning() {
        let alertController: UIAlertController = UIAlertController(title: "Error!", message: "Please fill in every field.", preferredStyle: .alert)
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in NSLog("Alert dismissed")}
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
            
        }
    
    @objc func adjustInputView(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


