//
//  Spots.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/12/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Spots {
    var spotArray = [Spot]()
    var db: Firestore! // saving the newly added location to the spots.array
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshott listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = []  // start out w/ nothing
            // there are query snapShot!.documents.count documents in the spot snapshot
            for document in querySnapshot!.documents {
                let spot = Spot(dictionary: document.data())  // creating new spot for each document
                    spot.documentID = document.documentID
                    self.spotArray.append(spot)
                }
                completed()
            }
        }
    }

