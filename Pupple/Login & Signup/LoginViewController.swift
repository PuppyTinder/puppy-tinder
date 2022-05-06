//
//  LoginViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/5/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.becomeFirstResponder()
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let user = user
            {
                if user["emailVerified"] != nil && user["emailVerified"] as! Bool == true
                {
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = main.instantiateViewController(withIdentifier: "HomeTabBarController")
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
                    delegate.window?.rootViewController = tabBarController
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
                else
                {
                    self.emailVerification()
                }
                
            }
            else
            {
                self.showWarning()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // When username or password is incorrect
    func showWarning() {
        let alertController: UIAlertController = UIAlertController(title: "Error!", message: "Incorrect username and/or password was entered.", preferredStyle: .alert)
       
        self.present(alertController, animated: true, completion: nil)
        let delay = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func emailVerification() {
        let alertController: UIAlertController = UIAlertController(title: "Please verify your email!", message: "You must verify your email to use Pupple.", preferredStyle: .alert)
       
        self.present(alertController, animated: true, completion: nil)
        let delay = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
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
