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
    let genders = ["","Male", "Female"]
    var breedDictionary = DogBreed(message: ["":[""]])
    var breedArray : [String] = []
    
    // Picker Views
    var genderPickerView = UIPickerView()
    var breedPickerView = UIPickerView()
    
    // User Defaults
    let defaults = UserDefaults.standard
    let GENDER_KEY = "gender_key"
    let BREED_KEY = "breed_key"
    let LOCATION_KEY = "location_key"

    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        initializeUI()
        
        requestBreeds{ data in
            self.breedDictionary = data!
            let array = self.breedDictionary.message!.keys.sorted()
            self.breedArray.append("")
            for breed in array
            {
                self.breedArray.append(breed.capitalized)
            }
        }
        
        updateFilterPreferences()
        defaults.synchronize()
    }

    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = tabbarVC
        delegate.window?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
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
        else
        {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1
        {
            genderTextField.text = genders[row]
            defaults.set(genderTextField.text, forKey: GENDER_KEY)
            genderTextField.resignFirstResponder()
        }
        else if pickerView.tag == 2
        {
            breedTextField.text = breedArray[row]
            defaults.set(breedTextField.text, forKey: BREED_KEY)
            breedTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initializeUI()
    {
        locationTextField.delegate = self
        breedTextField.delegate = self
        genderTextField.delegate = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        breedPickerView.delegate = self
        breedPickerView.dataSource = self
        genderPickerView.tag = 1
        breedPickerView.tag = 2
        
        genderTextField.inputView = genderPickerView
        breedTextField.inputView = breedPickerView
    }
    
    func updateFilterPreferences()
    {
        let genderPreference = defaults.string(forKey: GENDER_KEY)
        let breedPreference = defaults.string(forKey: BREED_KEY)
        let locationPreference = defaults.string(forKey: LOCATION_KEY)
        
        genderTextField.text = genderPreference
        breedTextField.text = breedPreference
        locationTextField.text = locationPreference
    }
    
    @IBAction func resetPreferences(_ sender: Any) {
        defaults.removeObject(forKey: GENDER_KEY)
        defaults.removeObject(forKey: BREED_KEY)
        defaults.removeObject(forKey: LOCATION_KEY)
        defaults.set("", forKey: GENDER_KEY)
        defaults.set("", forKey: BREED_KEY)
        defaults.set("", forKey: LOCATION_KEY)
        updateFilterPreferences()
    }
    
    @IBAction func setLocation(_ sender: Any) {
        let location = locationTextField.text
        defaults.set(location, forKey: LOCATION_KEY)
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
