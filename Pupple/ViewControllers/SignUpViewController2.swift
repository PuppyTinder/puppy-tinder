//
//  SignUpViewController2.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit

class SignUpViewController2: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
