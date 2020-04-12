//
//  File.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/12/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Spot {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "longitude": longitude, "latitude": latitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID] // save하려면 write spot.dictionary! and all of these will come together in the format we need to save it
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
        
    }
    convenience init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "") // any convenience init should call init
    }
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have valid postingUserID")
            return completed(false)
            
        }
        self.postingUserID = postingUserID
        //create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we have saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error  = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                }else{
                    print("^^^ Document updated with red ID \(ref.documentID)")
                    completed(true)
                }
                
            }
        }else{ // if we don't have save record
            var ref: DocumentReference? = nil // Let firestore create the new document ID
            ref = db.collection("spots").addDocument(data: dataToSave) { error in
                if let error  = error {
                    print("*** ERROR: creating new document")
                    completed(false)
                }else{
                    print("^^^ new document created with red ID \(ref?.documentID ?? "unknown")")
                    completed(true)
                }
                
                
            }
        }
    }
}

