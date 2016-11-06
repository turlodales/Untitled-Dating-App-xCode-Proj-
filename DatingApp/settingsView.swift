//
//  settingsView.swift
//  datingapp
//
//  Created by user on 27/02/2016.
//  Copyright © 2016 Dyc Studio. All rights reserved.
//

import Foundation
import FlatUIKit
import Alamofire

class settingsView : UIView {
    
    @IBOutlet weak var yourGender: UISwitch!
    @IBOutlet weak var genderPref: UISwitch!
    @IBOutlet weak var searchDistance: UISlider!
    @IBOutlet weak var searchMiles: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    var isFirst : String!
    var genderS : String!
    var prefGenderS : String!
    var pvc : MainViewController!
    
    @IBOutlet weak var saveButton: FUIButton!
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let currentValue = String(Int(sender.value))
        searchMiles.text = currentValue
        
    }
    
    @IBAction func save(_ sender: AnyObject) {
        
       
        if(self.yourGender.isOn == true){
            self.genderS = "male"
        } else {
            self.genderS = "female"
        }
        
        if(self.genderPref.isOn == true){
            self.prefGenderS = "male"
        } else {
            self.prefGenderS = "female"
        }
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")! as String
        let searchd = Int(self.searchDistance.value)
        
        let params = ["searchdist":searchd,"token":token,"gender":self.genderS,"prefgender":self.prefGenderS] as [String : Any]

        Alamofire.request(.POST, "http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/api/updateprefs", parameters: params as! [String : AnyObject]).responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let first = self.isFirst {
                        if (first == "yes"){
                            self.pvc.showProfile("yes")
                        } else {
                            self.pvc.showHome()
                        }
                    }
                    
                }
        }
        
        

        
        
        
    }
    
}
