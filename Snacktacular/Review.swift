//
//  Review.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/20/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date, "documentID": documentID] // save하려면 write spot.dictionary! and all of these will come together in the format we need to save it
    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
    }
}

func saveData(spot: Spot, completed: @escaping (Bool) -> ()) { //passing spot by spot: Spot method
    let db = Firestore.firestore() //db = database
    
    //create the dictionary representing the data we want to save
    let dataToSave = self.dictionary // go to class, create dictionary what we need to save (what we did on top)!
    // if we have saved a record, we'll have a documentID
    if spot.documentID != "" {
        let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID) //documentID: name of the review of the particular area!
        ref.setData(dataToSave) { (error) in
            if let error  = error {
                print("*** ERROR: updating document \(spot.documentID) in spot \(self.documentID) \(error.localizedDescription)")
                completed(false)
            }else{
                print("^^^ Document updated with red ID \(ref.documentID)")
                completed(true)
            }
            
        }
    }else{ // adding new documentID
        var ref: DocumentReference? = nil // Let firestore create the new document ID
        ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
            if let error = error {
                print("*** ERROR: creating new document in spot \(spot.documentID) for new review document ID \(error.localizedDescription)")
                completed(false)
            }else{
                print("^^^ new document created with red ID \(ref?.documentID ?? "unknown")")
                completed(true)
            }
            
            
        }
    }
}


