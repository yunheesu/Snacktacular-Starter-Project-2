//
//  SpotDetailViewController.swift
//  Snacktacular
//
//  Created by John Gallaugher on 3/23/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class SpotDetailViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var spot: Spot!
    let regionDistance: CLLocationDistance = 750 //750 meters, or about a half a mile
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false // doesn't cancel out of what we just cancelled
        self.view.addGestureRecognizer(tap)
        
        //        mapView.delegate = self // whenever we have smth to do w/ map, we call main class
        
        if spot == nil { // we are adding a new record, fields should be editable
            spot = Spot() //declare Spot with all empty value  <called convenience initializer>
            getLocation()
            
            //editable field should have a border around them (make UIVIew+addBorder for clarity)
            nameField.addBorder(width: 0.5, radius: 5.0, color: .blue)
            addressField.addBorder(width: 0.5, radius: 5.0, color: .red)
    
        } else { // viewing an existing spot, so editing should be disabled
            //disable text editing
            nameField.isEnabled = false
            addressField.isEnabled = false
            //disabled fields should have white background
            nameField.backgroundColor = UIColor.white // or UIColor.clear
            addressField.backgroundColor = UIColor.white
            //"save" and "cancel" button should be hidden
            saveBarButton.title = "" // hide theh button instead of using isEnabled
            cancelBarButton.title = ""
            //hide toolbar so that "look up place" isn't available
            navigationController?.setToolbarHidden(true, animated: true) // toolbar all disappears , we lose all toolbar so, unhide navigation controller toolbar on the listviewpage viewWillAppear
        }
        
        let region = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance) // centering the map to the region 
        mapView.setRegion(region, animated: true)
        updateUserInterface()
    }
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        saveBarButton.isEnabled = !(nameField.text == "") // = ! 가 is else statement 과 똑같다
    }
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder() //sender = textField --> removes done key when anywhere is tapped
        spot.name = nameField.text!
        spot.address = addressField.text!
        updateUserInterface() // saving spot address
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface(){
        nameField.text = spot.name
        addressField.text = spot.address
        updateMap()
        
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations) // removing multiple balloons for all possible locations
        mapView.addAnnotation(spot)
        mapView.setCenter(spot.coordinate, animated: true)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AddReview", sender: nil) // creating a segway to reviewTableViewController
    }
    
    @IBAction func lookupPlacePressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        spot.name = nameField.text!
        spot.address = addressField.text!
        spot.saveData { success in
            if success {
                self.leaveViewController()
            }else{
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}
extension SpotDetailViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        spot.name = place.name!
        spot.address = place.formattedAddress ?? ""
        spot.coordinate = place.coordinate
        
        dismiss(animated: true, completion: nil)
        updateUserInterface()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
extension SpotDetailViewController: CLLocationManagerDelegate { //from the website!
    
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .restricted:
            showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsActions = UIAlertAction(title: "Settings", style: .default) { value in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsActions)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard spot.name == "" else {
            return
        }
        let geoCoder = CLGeocoder()
        var name = ""
        var address = ""
        currentLocation = locations.last
        spot.coordinate = currentLocation.coordinate // gets latitude and longtitude!
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
            if placemarks != nil {
                let placemark = placemarks?.last
                name = placemark?.name ?? "name unknown"
                // need to import Contacts to use this code:
                if let postalAddress = placemark?.postalAddress {
                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                }
            } else {
                print("Error retrieving place. Error code: \(error!.localizedDescription)")
            }
            self.spot.name = name
            self.spot.address = address
            self.updateUserInterface()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}

