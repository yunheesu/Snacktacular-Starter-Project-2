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
import Firebase
import FirebaseUI
import GoogleSignIn

class SpotsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var spots: Spots!
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate Protocol to receive callback
        authUI?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        spots = Spots() // empty class for spots
        spots.spotArray.append(Spot(name: "El Pelon", address: "Comm. Ave", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        spots.spotArray.append(Spot(name: "Shake Shack", address: "Chestnut Hill", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        spots.spotArray.append(Spot(name: "Pino's Pizza", address: "Cleveland Circle", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: ""))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
          FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil { // do we have a user?
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
        
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
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            tableView.isHidden = true
            signIn()
        }catch{
            tableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
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

extension SpotsListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            tableView.isHidden = false
            print("*** We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController { // customizing the viewcontroller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView) // addSubview = adding UI object to bigger view
        
        return loginViewController
    }
}
