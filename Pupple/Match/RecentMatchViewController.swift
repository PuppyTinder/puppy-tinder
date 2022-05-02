//
//  RecentMatchViewController.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit
import Parse
import AlamofireImage
import CoreMedia

class RecentMatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - IBOutlet
  
    @IBOutlet weak var matchCollectionView: UICollectionView!
    @IBOutlet weak var messageTableView: UITableView!
    
    //MARK: - Vars
    var matches = [PFObject]() // creates an empty array of matches
    var matchesUser = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchCollectionView.dataSource = self
        matchCollectionView.delegate = self
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
    }
    
    // reload a page each time new match occurs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchQuery()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return matches.count
    }
    
    //MARK: - match Query
    // i) get user's dog's match that has an array of other dogs
    // ii) save that array of dog?
    
    func matchQuery() {
        
        let user = PFUser.current()!
        
        let userDogquery = PFQuery(className: "Dog")
        userDogquery.includeKeys(["name", "matches", "dog_photo", "ownerid"])
        userDogquery.whereKey("ownerid", equalTo: user) // contrasint to get the current user's dog
        
        let userDogOwnerquery = PFQuery(className: "_User")
        userDogOwnerquery.includeKeys(["user_photo","firstname"])
        
        var dogArray = [PFObject]()
        userDogquery.findObjectsInBackground { userDog, error in
            if userDog != nil {
                dogArray = userDog!
                
                for currentUserDog in dogArray {
                    let dogMatches = currentUserDog["matches"] as! [PFObject]
                    self.matches = dogMatches
                    
                    for dog in dogMatches
                    {
                        let matchOwner = dog["ownerid"] as! PFObject
                        userDogOwnerquery.getObjectInBackground(withId: matchOwner.objectId!) { owner, error in
                            self.matchesUser.append(owner!)
                            self.messageTableView.reloadData()
                        }
                    }
    
                    self.matchCollectionView.reloadData() //reload the data
                }
            }
        }// end of first query
     
        
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentMatchCollectionViewCell", for: indexPath) as! RecentMatchCollectionViewCell // grab the cell
        //print(matches[indexPath.item].objectId)
        let match = matches[indexPath.item] as! PFObject// grab a particular match
        cell.puppyNameLabel.text = match["name"] as? String
        
        let imageFile = match["dog_photo"] as! PFFileObject
        let imageUrl = imageFile.url!
        let url = URL(string: imageUrl)
        
        //MARK: - GOTTA MAKE THE IMAGE ROUND!!!!!

        cell.avatarImageView.af.setImage(withURL: url!)
        cell.avatarImageView.layer.cornerRadius = 35
        return cell
      }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MatchandMessageTableViewCell // grab the cell
        
        let match = matches[indexPath.row]
        
        cell.userNameLabel.text = match["name"] as! String
        cell.lastMessageLabel.text = ""
        
        let imageFile = match["dog_photo"] as! PFFileObject
        let imageUrl = imageFile.url!
        let url = URL(string: imageUrl)
        
        cell.dogImageView.af.setImage(withURL: url!)
        cell.dogImageView.layer.cornerRadius = 30
        
        let matchUser = matchesUser[indexPath.row]
        let userImageFile = matchUser["user_photo"] as! PFFileObject
        let userImageUrl = userImageFile.url!
        let userUrl = URL(string: userImageUrl)
        
        cell.userImageView.af.setImage(withURL: userUrl!)
        cell.userImageView.layer.cornerRadius = 15
        return cell
    }
}
