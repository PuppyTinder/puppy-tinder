//
//  SignUpViewController2.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class SignUpViewController2: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var vaccinatedTextField: UITextField!
    @IBOutlet weak var neuteredTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var placeholderImageView: UIImageView!
    
    // Array of options for picker views
    let genders = ["","Male", "Female"]
    let choices = ["", "Yes", "No"]
    let sizes = ["", "Small", "Medium", "Large"]
    var breedDictionary = DogBreed(message: ["":[""]])
    var breedArray : [String] = []
    
    var genderPickerView = UIPickerView()
    var vaccinatedPickerView = UIPickerView()
    var neuteredPickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    var breedPickerView = UIPickerView()
    let imagePicker = UIImagePickerController()
    
    // User information
    var username: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var birthday: String?
    var userPhotoData: Data?
    var mobileNumber: String?
    var location: String?
    var email: String?
    
    
    // Images
    var dogImage : UIImage?
    var userImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        
        // Pushes view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        requestBreeds{ data in
            self.breedDictionary = data!
            let array = self.breedDictionary.message!.keys.sorted()
            for breed in array
            {
                self.breedArray.append(breed.capitalized)
            }
            
        }
    }
    
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
        dogImageView.image = scaledImage
        dogImage = image
        placeholderImageView.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        // Checks for any missing fields before proceeding with the sign up process
        if nameTextField.text == "" || genderTextField.text == "" || breedTextField.text == "" ||
            sizeTextField.text == "" || vaccinatedTextField.text == "" || neuteredTextField.text == "" || dogImageView.image == nil
        {
            showWarning()
            return
        }
        let dog_name = nameTextField.text!
        let dog_gender = genderTextField.text!
        let breed = breedTextField.text!
        let size = sizeTextField.text!
        //let dogImageData = dogImageView.image!.pngData()
        let dogImageData = dogImage?.pngData() // get the original image aspect ratio 
        
        let user = PFUser() // Create the user
        let dog = PFObject(className: "Dog") // Create a dog
        
        //Set user details
        user.username = username
        user.password = password
        user.email = email
        user["firstname"] = firstname
        user["lastname"] = lastname
        user["birthday"] = birthday
        user["phone_number"] = mobileNumber
        user["location"] = location
        let userFile = PFFileObject(name: "user.png", data: userPhotoData!)
        user["user_photo"] = userFile
        
        //Set dog details
        var vaccinated : Bool?
        var neutered : Bool?
        
        if vaccinatedTextField.text == "Yes"
        {
            vaccinated = true
        }
        else
        {
            vaccinated = false
        }
        
        if neuteredTextField.text == "Yes"
        {
            neutered = true
        }
        else
        {
            neutered = false
        }
        
        dog["name"] = dog_name
        dog["gender"] = dog_gender
        dog["breed"] = breed.capitalized
        dog["size"] = size
        dog["vaccinated"] = vaccinated
        dog["fixed"] = neutered
        let dogFile = PFFileObject(name: "dog.png", data: dogImageData!)
        
        // Perform sign up for user then dog
        user.signUpInBackground { success, error in
            if success
            {
                dog["ownerid"] = user
                dog["dog_photo"] = dogFile
                dog.saveInBackground { success, error in
                    if success
                    {
                        dog.saveInBackground()
                        self.performSegue(withIdentifier: "signupSuccessSegue", sender: nil)
                    }
                    else
                    {
                        self.signUpFailure()
                    }
                }
            }
            else
            {
                self.signUpFailure()
            }
        }
        
    }
    
    //Direct the user back to the welcome screen on cancel
    @IBAction func cancelSignUp(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let WelcomeViewController = main.instantiateViewController(withIdentifier: "WelcomeViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = WelcomeViewController
    }
    
    // Missing text field information
    func showWarning() {
        let alertController: UIAlertController = UIAlertController(title: "Error!", message: "Please fill in missing fields.", preferredStyle: .alert)
       
        self.present(alertController, animated: true, completion: nil)
         
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }

    func signUpFailure() {
        let alertController: UIAlertController = UIAlertController(title: "Error", message: "Failed to sign up!", preferredStyle: .alert)
      
        self.present(alertController, animated: true, completion: nil)
        let delay = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
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
        else if pickerView.tag == 4
        {
            return genders.count
        }
        else if pickerView.tag == 5
        {
            return breedArray.count
        }
        else
        {
            return 0
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
        else if pickerView.tag == 4
        {
            return genders[row]
        }
        else if pickerView.tag == 5
        {
            return breedArray[row]
        }
        else
        {
            return ""
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
        else if pickerView.tag == 4
        {
            genderTextField.text = genders[row]
            genderTextField.resignFirstResponder()
        }
        else if pickerView.tag == 5
        {
            breedTextField.text = breedArray[row]
            breedTextField.resignFirstResponder()
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
        breedPickerView.delegate = self
        breedPickerView.dataSource = self
        breedPickerView.tag = 5
        
        sizeTextField.inputView = sizePickerView
        vaccinatedTextField.inputView = vaccinatedPickerView
        neuteredTextField.inputView = neuteredPickerView
        genderTextField.inputView = genderPickerView
        breedTextField.inputView = breedPickerView
    }
    
    @objc func adjustInputView(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification
        {
            self.view.frame.origin.y = 0 // reset frame before adjusting
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            self.view.frame.origin.y -= adjustmentHeight
        }
        else
        {
            self.view.frame.origin.y = 0
        }
    }
}

extension SignUpViewController2 {
    
    func requestBreeds(completion :@escaping ( _ data : DogBreed?) -> ())
    {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        
        // API request
        AF.request(urlString)
          .validate()
          .responseDecodable(of: DogBreed.self) { (response) in
            guard let breed = response.value else { return }
              completion(breed)
          }
    }
}
