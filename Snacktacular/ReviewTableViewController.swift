//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/20/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var reviewView: UITextView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    @IBOutlet var starButtonCollection: [UIButton]!
    
    var rating = 0 {//starting of 0
        didSet { // execute every time raitng changes
            for starButton in starButtonCollection {
                let image = UIImage(named: (starButton.tag < rating ? "star-filled" : "star-empty"))
                     // meaning, if we have 4 in rating, it will go through 0,1,2,3 as all are less than rating; if tag 4 is not less than 4, it won't go to tag 5
                starButton.setImage(image, for: .normal)
            }
            print(" >>> new rating \(rating)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false // doesn't cancel out of what we just cancelled
        self.view.addGestureRecognizer(tap)

    }
    func leaveViewController() {
         let isPresentingInAddMode = presentingViewController is UINavigationController
         if isPresentingInAddMode {
             dismiss(animated: true, completion: nil)
         } else {
             navigationController?.popViewController(animated: true)
         }
     }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1 // add one since we are zero indexed
        //how do we update the star buttons?
        
    }
    
    @IBAction func reviewTitlechanged(_ sender: UITextField) {
    }
    
    @IBAction func returnTitleDonePressed(_ sender: UITextField) {
        //done button = primary action triggered
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}
