//
//  ViewController.swift
//  Snacktacular
//
//  Created by John Gallaugher on 3/23/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//
// IMPORTANT!!!
// Below is a replacement for the func signIn() shown in the video for Ch. 9.3 in Textbook v.3. AFTER entering func signIn() as shown in the video, uncomment the function below, cut it from this location, and paste it over the func signIn() that you just wrote. You can delete this comment once you've replaced func signIn()
//
//func signIn() {
//    let providers: [FUIAuthProvider] = [
//        FUIGoogleAuth(),
//    ]
//    let currentUser = authUI.auth?.currentUser
//    if authUI.auth?.currentUser == nil {
//        self.authUI?.providers = providers
//        let loginViewController = authUI.authViewController()
//        loginViewController.modalPresentationStyle = .fullScreen
//        present(loginViewController, animated: true, completion: nil)
//    } else {
//        tableView.isHidden = false
//    }
//}

import UIKit
import CoreLocation

class SpotsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var spots: Spots!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        spots = Spots() // empty class for spots
        spots.spotArray.append(Spot(name: "El Pelon", address: "Comm. Ave", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        spots.spotArray.append(Spot(name: "Shake Shack", address: "Chestnut Hill", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        spots.spotArray.append(Spot(name: "Pino's Pizza", address: "Cleveland Circle", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSpot" {
            let destination = segue.destination as! SpotDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow! // force unwrapp because I know that this is the segway
            destination.spot = spots.spotArray[selectedIndexPath.row]
        } else { // clicking plus
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
        
    }
}


extension SpotsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.spotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpotsTableViewCell // make sure it's a subclass of SpotsTableViewCell!
        cell.nameLabel.text = spots.spotArray[indexPath.row].name // indexPath.row = gives element of spot
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // setting the hieght of the table
    }
    
}
