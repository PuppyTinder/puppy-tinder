//
//  DogProfileFeedViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/19/22.
//

import UIKit

class DogProfileFeedViewController: UIViewController {

    
    @IBOutlet weak var dogView: UIView!
    @IBOutlet weak var ownerView: UIView!
    
    //Dog View Outlets
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dogAgeLabel: UILabel!
    @IBOutlet weak var dogSizeLabel: UILabel!
    @IBOutlet weak var dogAboutLabel: UILabel!
    @IBOutlet weak var fixedLabel: UILabel!
    @IBOutlet weak var vaccinatedLabel: UILabel!
    
    //Owner View Outlets
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerGenderLabel: UILabel!
    @IBOutlet weak var ownerAgeLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerAboutLabel: UILabel!
    @IBOutlet weak var ownerInstagramButton: UIButton!
    @IBOutlet weak var ownerSnapchatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
