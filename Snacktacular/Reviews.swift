//
//  Reviews.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/20/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        guard spot.documentID != "" else {
            return // to stop crashing 
        }
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
        guard error == nil else {
            print("*** ERROR: adding the snapshott listener \(error!.localizedDescription)")
            return completed()
        }
        self.reviewArray = []  // start out w/ nothing
        // there are query snapShot!.documents.count documents in the spots snapshot
        for document in querySnapshot!.documents {
            let review = Review(dictionary: document.data())  // creating new spot for each document
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
