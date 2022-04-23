//
//  UserProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/22/22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var dogImageView: UIImageView!{ didSet { dogImageView.image = dogImage } }
    
    @IBOutlet weak var dogNameLabel: UILabel!{ didSet{ dogNameLabel.text = dogName } }
    
    @IBOutlet weak var dogBreedLabel: UILabel!{ didSet{ dogBreedLabel.text = breed } }
    
    @IBOutlet weak var genderIconView: UIImageView!{ didSet{ genderIconView.image = gender } }
    
    @IBOutlet weak var dogLocationLabel: UILabel!{ didSet{ dogLocationLabel.text = location } }
    
    @IBOutlet weak var dogSizeLabel: UILabel!{ didSet{ dogSizeLabel.text = size } }
    
    @IBOutlet weak var fixedLabel: UILabel!{ didSet{ fixedLabel.text = fixed } }
    
    @IBOutlet weak var vaccinatedLabel: UILabel!{ didSet{ vaccinatedLabel.text = vaccinated } }
    
    
    
    @IBOutlet weak var ownerNameLabel: UILabel!{ didSet{ ownerNameLabel.text = ownerName } }
    
    @IBOutlet weak var ownerImageview: UIImageView!{ didSet{ ownerImageview.image = ownerImage } }
    
    @IBOutlet weak var aboutLabel: UILabel!{ didSet{aboutLabel.text = ""}}
    
    
    var dogName: String?
    var dogImage: UIImage?
    var ownerImage: UIImage?
    var location: String?
    var breed: String?
    var gender: UIImage?
    var size: String?
    var vaccinated: String?
    var fixed: String?
    var ownerName: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ownerImageview.layer.cornerRadius = 30
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        dogSizeLabel.text = size
        vaccinatedLabel.text = vaccinated
        fixedLabel.text = fixed
        ownerNameLabel.text = ownerName
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
