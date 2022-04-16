//
//  SampleSwipeableCard.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import UIKit
import CoreMotion
import AlamofireImage

class SampleSwipeableCard: SwipeableCardViewCard {

    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet var backgroundContainerView: UIView!
    
    // Core Motion Manager
    private let motionManager = CMMotionManager()
    
    var viewModel: SampleSwipeableCellViewModel?
    {
        didSet{ configure(forViewModel: viewModel) }
    }
    
    private func configure(forViewModel viewModel: SampleSwipeableCellViewModel?)
    {
        if let viewModel = viewModel {
            dogNameLabel.text = viewModel.dog_name
            locationLabel.text = viewModel.location
            breedLabel.text = viewModel.breed
            userImageView.af.setImage(withURL: viewModel.owner_image)
            dogImageView.af.setImage(withURL: viewModel.dog_image) 
            genderImageView.image = viewModel.gender
            
            
            backgroundContainerView.layer.borderWidth = 1
            backgroundContainerView.layer.cornerRadius = 20.0
            backgroundContainerView.layer.borderColor = CGColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 0.1)
            dogImageView.layer.cornerRadius = 20
            dogImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            userImageView.layer.cornerRadius = 30
        }
    }
}
