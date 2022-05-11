//
//  SignupSuccessViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/11/22.
//

import UIKit

class SignupSuccessViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.signupComplete), userInfo: nil, repeats: false)
    }
    
    @objc func signupComplete()
    {
        performSegue(withIdentifier: "goToLoginSegue", sender: nil)
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
