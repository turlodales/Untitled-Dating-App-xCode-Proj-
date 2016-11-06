//
//  RegisterViewController.swift
//  datingapp
//
//  Created by Taheer on 22/02/2016.
//  Copyright © 2016 Dyc Studio. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class RegisterViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate  {
   
    var loginView : FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var logView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.frame = CGRect(x: 0, y: 0, width: self.logView.frame.size.width, height: self.logView.frame.size.height)
        self.logView.addSubview(loginView)
        loginView.isUserInteractionEnabled = true
        loginView.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
        loginView.delegate = self
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(true)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil)
        {
            //handle error
            print(error)
        } else {
            
            returnUserData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let id : NSString = result.value(forKey: "id") as! String
                let name : NSString = result.value(forKey: "name") as! String
                let gender : NSString = result.value(forKey: "gender") as! String
                let birthday : NSString = result.value(forKey: "birthday") as! String
                let email : NSString = result.value(forKey: "email") as! String
                var prefgender : String = "none"
                if(gender == "male"){
                    prefgender = "female"
                } else {
                    prefgender = "male"
                }
                
                var fullname = name.components(separatedBy: " ")
                let username : String = fullname[0]
                
                let params = ["facebookid": id, "username": username, "fullname": name, "gender": gender,"birthday":birthday,"email": email, "prefgender": prefgender, "searchdist" : 100] as [String : Any]
                
                Alamofire.request(.POST, "http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/register", parameters: params)
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            let token : NSString = JSON.value(forKey: "token") as! String
                            
                            let defaults = UserDefaults.standard
                            defaults.set(token, forKey: "token")
                            
                            let stboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            
                            let vc = stboard.instantiateViewController(withIdentifier: "main")
                            
                            self.present(vc, animated: true, completion: nil)
                    
                        }
                }
            }
        })
    }
}
