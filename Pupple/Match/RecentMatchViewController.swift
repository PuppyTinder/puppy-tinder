//
//  RecentMatchViewController.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit

class RecentMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    
/*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentMatchCollectionViewCell", for: indexPath) as! RecentMatchCollectionViewCell
        
        return cell
}
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    


}
*/
