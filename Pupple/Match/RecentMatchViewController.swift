//
//  RecentMatchViewController.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit
import Parse
import AlamofireImage

class RecentMatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Vars
    var matches = [PFObject]() // creates an empty array of matches
    
    var puppyNameLabel: String?
    var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // reload a page each time new match occurs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentMatchCollectionViewCell", for: indexPath) as! RecentMatchCollectionViewCell
        
        var match = PFObject(className: "Dog")
        if collectionView == self.collectionView {
            match = matches[indexPath.item]
        }
        
        let query = PFQuery(className: "Dog")
        
        query.getObjectInBackground(withId: match.objectId!) { dog, error in
            if let error = error {
                print(error)
        }
            
            else if let dog = dog {
                let imageFile = dog["dog_photo"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                cell.avatarImageView.af.setImage(withURL: url)
                cell.puppyNameLabel.text = dog["name"] as? String
            }
        }
        return cell
    }
}
