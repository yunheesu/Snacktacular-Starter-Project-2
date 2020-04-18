//
//  SpotsListTableViewCell.swift
//  Snacktacular
//
//  Created by John Gallaugher on 3/23/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import CoreLocation

class SpotsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    //pass current location <needed to list location by nearest>
    var currentLocation: CLLocation! // only pass location if we have current location
    var spot: Spot!
    
    func configureCell(spot: Spot) { // call and pass spot
        nameLabel.text = spot.name
        //calculate distance here
        
        guard let currentLocation = currentLocation else {
            return // if we do have current location, we use this in our code!
        }
        let distanceInMeters = currentLocation.distance(from: spot.location) // gives distance in meters
        let distanceString = "Distance: \( (distanceInMeters * 0.00062137).roundTo(places: 2) ) miles"
        distanceLabel.text = distanceString
    }

}
