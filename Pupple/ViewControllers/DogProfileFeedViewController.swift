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
    @IBOutlet weak var dogImageView: UIImageView!{ didSet { dogImageView.image = dogImage } }
    @IBOutlet weak var dogNameLabel: UILabel!{ didSet{ dogNameLabel.text = dogName } }
    @IBOutlet weak var breedLabel: UILabel!{ didSet{ breedLabel.text = breed } }
    @IBOutlet weak var genderImageView: UIImageView!{ didSet{ genderImageView.image = gender } }
    @IBOutlet weak var locationLabel: UILabel!{ didSet{ locationLabel.text = location } }
    @IBOutlet weak var dogAgeLabel: UILabel!{ didSet{ dogAgeLabel.text = "N/A"} }
    @IBOutlet weak var dogSizeLabel: UILabel!
    @IBOutlet weak var dogAboutLabel: UILabel!{ didSet{dogAboutLabel.text = ""} }
    @IBOutlet weak var fixedLabel: UILabel!
    @IBOutlet weak var vaccinatedLabel: UILabel!
    
    //Owner View Outlets
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerGenderLabel: UILabel!{ didSet{ownerGenderLabel.text = "N/A"} }
    @IBOutlet weak var ownerAgeLabel: UILabel!{ didSet{ownerAgeLabel.text = "N/A"}}
    @IBOutlet weak var occupationLabel: UILabel!{ didSet{occupationLabel.text = "N/A"}}
    @IBOutlet weak var educationLabel: UILabel!{ didSet{educationLabel.text = "N/A"}}
    @IBOutlet weak var ownerImageView: UIImageView!{ didSet{ ownerImageView.image = ownerImage } }
    @IBOutlet weak var ownerAboutLabel: UILabel!{ didSet{ownerAboutLabel.text = ""}}
    @IBOutlet weak var ownerInstagramButton: UIButton!
    @IBOutlet weak var ownerSnapchatButton: UIButton!
    
    // Dog variables
    var dogName: String?
    var dogImage: UIImage?
    var ownerImage: UIImage?
    var location: String?
    var breed: String?
    var gender: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ownerImageView.layer.cornerRadius = 50
    }
    
    override func viewWillLayoutSubviews() {
            dogAboutLabel.sizeToFit()
            ownerAboutLabel.sizeToFit()
        }
    
    
    @IBAction func goToInstagram(_ sender: Any) {
        let instaUrl = URL(string: "https://www.instagram.com/" + (ownerInstagramButton.titleLabel?.text)!)
        UIApplication.shared.open(instaUrl!)
    }
    
    @IBAction func goToSnapchat(_ sender: Any) {
        let snapchatUrl = URL(string: "http://www.snapchat.com/add/" + (ownerSnapchatButton.titleLabel?.text)!)
        UIApplication.shared.open(snapchatUrl!)
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
