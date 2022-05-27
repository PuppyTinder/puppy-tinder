//
//  SignUpViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/5/22.
//

import UIKit
import Parse
import AlamofireImage
import PhoneNumberKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var placeholderImageView: UIImageView!
    
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    var username: String? = ""
    var password: String? = ""
    var firstname: String? = ""
    var lastname: String? = ""
    var birthday: String? = ""
    var phone: String? = ""
    var location: String? = ""
    var email: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
   /* ------ Functions to store user input ------ */
    
    // Will launch camera when button is selected
    @IBAction func onCamera(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onPhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 141, height: 133)
        let scaledImage = image.af.imageScaled(to: size)
        userImageView.image = scaledImage
        placeholderImageView.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setUsername(_ sender: Any) {
        username = usernameTextField.text!
    }
    
    @IBAction func setPassword(_ sender: Any) {
        if(passwordTextField.text!.count < 6)
        {
            passwordSizeVerification()
            passwordTextField.text = ""
        }
        else
        {
            password = passwordTextField.text!
        }
    }
    
    @IBAction func setFirstName(_ sender: Any) {
        firstname = firstnameTextField.text!
    }
    
    @IBAction func setLastName(_ sender: Any) {
        lastname = lastnameTextField.text!
    }
    
    @IBAction func setDOB(_ sender: Any) {
        // Calculate age
        if(birthdayTextField.text != "")
        {
            let dob = birthdayTextField.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.date(from: dob)
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: dateFormatter.date(from: dob)!, to: now)
            let age = ageComponents.year!
            
            // Verify if user is at least 13 years old
            if(age < 13)
            {
                birthdayVerification()
                birthdayTextField.text = ""
            }
            else
            {
                birthday = birthdayTextField.text!

            }
        }
    }
    
    @IBAction func setMobileNumber(_ sender: Any) {
        phone = mobileNumberTextField.text!

    }
    
    @IBAction func setLocation(_ sender: Any) {
        location = locationTextField.text!
  
    }
    
    @IBAction func setEmail(_ sender: Any) {
        // Used to verify if a valid email express was inputted
        if emailTextField.text != ""
        {
            let emailRegularExpression = "^[A-Z0-9a-z.-_]+@[A-Z0-9a-z-_.]+\\.[A-Za-z]{2,6}$"
                    
            if let text = self.emailTextField.text,
                   text.range(of: emailRegularExpression, options: .regularExpression) != nil
                    {
                        email = emailTextField.text!
                    }
                    else {
                        emailVerificationAlert()
                        emailTextField.text = ""
                    }
        }
    }
    
    
    // Go to page 2 of the sign up form and preserve the values from the first page
    @IBAction func goToNextPage(_ sender: Any) {
   
        if(username == "" || password == "" || firstname == "" || lastname == "" || birthday == "" || phone == "" || location == "" || email == "" || userImageView.image == nil)
        {
            showWarning()
        }
        else
        {
            self.performSegue(withIdentifier: "signUpPage2Segue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signUpPage2Segue")
        {
            if(username != "" || password != "" || firstname != "" || lastname != "" || birthday != "" || phone != "" || location != "" || email != "" || userImageView.image != nil)
            {
                let signUpVC: SignUpViewController2 = segue.destination as! SignUpViewController2
                signUpVC.username = usernameTextField.text!
                signUpVC.password = passwordTextField.text!
                signUpVC.email = emailTextField.text!
                signUpVC.birthday = birthdayTextField.text!
                signUpVC.firstname = firstnameTextField.text!
                signUpVC.lastname = lastnameTextField.text!
                signUpVC.location = locationTextField.text!
                signUpVC.mobileNumber = mobileNumberTextField.text!
                signUpVC.userPhotoData = userImageView.image!.pngData()
            }
        }
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
        self.emailTextField.delegate = self
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width/2
        
        createDateKeyboard()
    }
    
    // Missing text field information
    func showWarning() {
        let alertController: UIAlertController = UIAlertController(title: "Error!", message: "Please fill in missing fields.", preferredStyle: .alert)
        //let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in NSLog("Alert dismissed")}
        //alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
         
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func emailVerificationAlert(){
        let alertController: UIAlertController = UIAlertController(title: "Please enter a valid email address!", message: "Your email address is required for authentication.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func birthdayVerification(){
        let alertController: UIAlertController = UIAlertController(title: "Underage!", message: "You must be at least 13 years old or older to use Pupple.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func passwordSizeVerification(){
        let alertController: UIAlertController = UIAlertController(title: "Password too short!", message: "A minimum of 6 characters is required.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
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
}


