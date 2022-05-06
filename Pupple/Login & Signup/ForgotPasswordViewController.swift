//
//  ForgotPasswordViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 5/6/22.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetPassword(_ sender: Any) {
        if emailTextField.text != ""
        {
            let email = emailTextField.text!
            PFUser.requestPasswordResetForEmail(inBackground: email) { success, error in
                if success
                {
                    self.success()
                }
                else
                {
                    self.emailVerificationAlert()
                }
            }
        }
        else { emptyTextField(); return }
        
       
    }
    
    func success(){
        let alertController: UIAlertController = UIAlertController(title: "Success!", message: "Please check your email for further instructions.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func emailVerificationAlert(){
        let alertController: UIAlertController = UIAlertController(title: "Email Address Not Found!", message: "A user with the provided email address could not be found in our system.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func emptyTextField(){
        let alertController: UIAlertController = UIAlertController(title: "Please enter your email address!", message: "Your email address is required for authentication.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
