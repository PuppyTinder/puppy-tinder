//
//  SignUpViewController2.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Parse
import AlamofireImage

class SignUpViewController2: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dogImageView: UIImageView!
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
    let LOCATION_KEY = "Location Key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
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
        dogImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let dog = PFObject(className: "Dog") // Get the current dog object
        
        let username = defaults.string(forKey: USERNAME_KEY)!
        let password = defaults.string(forKey: PASSWORD_KEY)!
        
        // Temporarily login the user
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if (user != nil)
            {
                
            }
        }
        
        let dog_name = nameTextField.text!
        let dog_gender = genderTextField.text!
        let breed = breedTextField.text!
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
        
        
        // Sign up the dog
        dog["name"] = dog_name
        dog["gender"] = dog_gender
        dog["breed"] = breed
        dog["size"] = size
        dog["vaccinated"] = vaccinated
        dog["fixed"] = neutered
        dog["ownerid"] = PFUser.current()!
       
        dog.saveInBackground { success, error in
            if (success)
            {
                let defaultImageData = UIImage(named: "upload_image")!.pngData()
                let defaultDogImage = PFFileObject(name: "default.png", data: defaultImageData!)
                defaultDogImage?.saveInBackground({ success, error in
                    if(success)
                    {
                        dog["dog_photo"] = defaultDogImage // Assign a default photo incase the user did not set one
                        dog.saveInBackground()
                    }
                })
                
                let imageData = self.dogImageView.image!.pngData()
                let file = PFFileObject(name: "dog.png", data: imageData!)
                file?.saveInBackground({ success, error in
                    if(success)
                    {
                        dog["dog_photo"] = file
                        dog.saveInBackground()
                    }
                })
                
                
                PFUser.logOut()
                self.performSegue(withIdentifier: "signupSuccessSegue", sender: nil)
                self.resetDefaults()
            }
            else
            {
                self.signUpFailure()
            }
        }
    }
    
    //Cancel the signup process and directs user back to the welcome screen
    @IBAction func cancelSignUp(_ sender: Any) {
        let username = defaults.string(forKey: USERNAME_KEY)!
        let password = defaults.string(forKey: PASSWORD_KEY)!
        
        // Temporarily login the user
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if (user != nil)
            {
                
            }
        }
        let user = PFUser.current()!
        user.deleteInBackground()
        resetDefaults()
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let WelcomeViewController = main.instantiateViewController(withIdentifier: "WelcomeViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = WelcomeViewController
    }
    
    func resetDefaults()
    {
        defaults.removeObject(forKey: USERNAME_KEY)
        defaults.removeObject(forKey: PASSWORD_KEY)
        defaults.removeObject(forKey: FIRSTNAME_KEY)
        defaults.removeObject(forKey: LASTNAME_KEY)
        defaults.removeObject(forKey: BIRTHDAY_KEY)
        defaults.removeObject(forKey: MOBILE_NUMBER_KEY)
        defaults.removeObject(forKey: LOCATION_KEY)
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
        
        dogImageView.layer.masksToBounds = true
        dogImageView.layer.cornerRadius = dogImageView.bounds.width/2
        
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
    
    @objc func adjustInputView(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification
        {
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
