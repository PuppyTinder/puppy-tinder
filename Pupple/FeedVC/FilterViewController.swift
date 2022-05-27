//
//  FilterViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 5/26/22.
//

import UIKit
import Alamofire

class FilterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    // Keyboard Options
    let genders = ["None","Male", "Female"]
    let sizes = ["None", "Small", "Medium", "Large"]
    var breedDictionary = DogBreed(message: ["":[""]])
    var breedArray : [String] = []
    
    // Picker Views
    var genderPickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    var breedPickerView = UIPickerView()
    
    // User Defaults
    let defaults = UserDefaults.standard
    let GENDER_KEY = "gender_key"
    let SIZE_KEY = "size_key"
    let BREED_KEY = "breed_key"
    let LOCATION_KEY = "location_key"
    
    // For Cancel
    var prevGender: String?
    var prevBreed: String?
    var prevLocation: String?
    var prevSize: String?

    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        
        requestBreeds{ data in
            self.breedDictionary = data!
            let array = self.breedDictionary.message!.keys.sorted()
            self.breedArray.append("None")
            for breed in array
            {
                self.breedArray.append(breed.capitalized)
            }
        }
        
        updateFilterPreferences()
        defaults.synchronize()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1
        {
            return genders.count
        }
        else if pickerView.tag == 2
        {
            return breedArray.count
        }
        else if pickerView.tag == 3
        {
            return sizes.count
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1
        {
            return genders[row]
        }
        else if pickerView.tag == 2
        {
            return breedArray[row]
        }
        else if pickerView.tag == 3
        {
            return sizes[row]
        }
        else
        {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1
        {
            if(genders[row] == "None")
            {
                genderTextField.text = ""
            }
            else
            {
                genderTextField.text = genders[row]
            }
            genderTextField.resignFirstResponder()
        }
        else if pickerView.tag == 2
        {
            if(breedArray[row] == "None")
            {
                breedTextField.text = ""
            }
            else
            {
                breedTextField.text = breedArray[row]
            }
            breedTextField.resignFirstResponder()
        }
        else if pickerView.tag == 3
        {
            if(sizes[row] == "None")
            {
                sizeTextField.text = ""
            }
            else
            {
                sizeTextField.text = sizes[row]
            }
            sizeTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initializeUI()
    {
        locationTextField.delegate = self
        sizeTextField.delegate = self
        breedTextField.delegate = self
        genderTextField.delegate = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        breedPickerView.delegate = self
        breedPickerView.dataSource = self
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        genderPickerView.tag = 1
        breedPickerView.tag = 2
        sizePickerView.tag = 3
        
        genderTextField.inputView = genderPickerView
        breedTextField.inputView = breedPickerView
        sizeTextField.inputView = sizePickerView
    }
    
    func updateFilterPreferences()
    {
        let genderPreference = defaults.string(forKey: GENDER_KEY)
        let breedPreference = defaults.string(forKey: BREED_KEY)
        let locationPreference = defaults.string(forKey: LOCATION_KEY)
        let sizePreference = defaults.string(forKey: SIZE_KEY)
        
        genderTextField.text = genderPreference
        breedTextField.text = breedPreference
        locationTextField.text = locationPreference
        sizeTextField.text = sizePreference
        prevGender = genderPreference
        prevBreed = breedPreference
        prevLocation = locationPreference
        prevSize = sizePreference
    }
    
    @IBAction func resetPreferences(_ sender: Any) {
        defaults.removeObject(forKey: GENDER_KEY)
        defaults.removeObject(forKey: BREED_KEY)
        defaults.removeObject(forKey: LOCATION_KEY)
        defaults.removeObject(forKey: SIZE_KEY)
        defaults.set("", forKey: GENDER_KEY)
        defaults.set("", forKey: BREED_KEY)
        defaults.set("", forKey: LOCATION_KEY)
        defaults.set("", forKey: SIZE_KEY)
        updateFilterPreferences()
        
        // Navigate to new feed view w/ preferences reset
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = tabbarVC
        delegate.window?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func setLocation(_ sender: Any) {
        // Check for invalid input eg: whitespaces only
        let alphanum = NSCharacterSet.alphanumerics
        let location = locationTextField.text!
        let range = location.rangeOfCharacter(from: alphanum)
        if let location = range
        {
            print("valid")
        }
        else
        {
            print("whitespaces")
            locationTextField.text = ""
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        defaults.removeObject(forKey: GENDER_KEY)
        defaults.removeObject(forKey: BREED_KEY)
        defaults.removeObject(forKey: LOCATION_KEY)
        defaults.removeObject(forKey: SIZE_KEY)
        defaults.set(prevBreed, forKey: BREED_KEY)
        defaults.set(prevGender, forKey: GENDER_KEY)
        defaults.set(prevLocation, forKey: LOCATION_KEY)
        defaults.set(prevSize, forKey: SIZE_KEY)
        self.dismiss(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        
        // Indicate the feed view to update according to the new preferences
        defaults.set(genderTextField.text, forKey: GENDER_KEY)
        defaults.set(breedTextField.text, forKey: BREED_KEY)
        defaults.set(sizeTextField.text, forKey: SIZE_KEY)
        let location = locationTextField.text
        defaults.set(location, forKey: LOCATION_KEY)
        
        // Navigate to new feed view w/ saved preferences
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = tabbarVC
        delegate.window?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// API call
extension FilterViewController {
    
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
