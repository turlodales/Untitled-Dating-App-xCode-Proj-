//
//  profileView.swift
//  datingapp
//
//  Created by user on 27/02/2016.
//  Copyright © 2016 Dyc Studio. All rights reserved.
//

import Foundation
import FlatUIKit
import Alamofire

class profileView : UIView {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var saveButton: FUIButton!
    
    @IBOutlet weak var introLabel: UILabel!
    var pvc : MainViewController!
    var isFirst : String!
    var imageUploading : String!
    
    @IBAction func imageOneTapped(_ sender: AnyObject) {
        pvc.imageUploading = "one"
        pvc.imageUpload()
    }
    
    @IBAction func imageTwoTapped(_ sender: AnyObject) {
        pvc.imageUploading = "two"
        pvc.imageUpload()
    }
    
    @IBAction func imageThreeTapped(_ sender: AnyObject) {
        pvc.imageUploading = "three"
        pvc.imageUpload()
    }
    
    
    
    @IBAction func saveProfileTapped(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")! as String
        let bio = self.bioField.text! as String
        print(bio)
        let params = ["token":token, "bio":bio]
        
        Alamofire.request(.POST, "http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/api/updatebio", parameters: params).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
//                if let first = self.isFirst {
//                    if (first == "yes"){
//                        self.pvc.showProfile("yes")
//                    } else {
                        self.pvc.showHome()
//                    }
//                }
                
            }
        }

        
        
    }
    
    
    


}
