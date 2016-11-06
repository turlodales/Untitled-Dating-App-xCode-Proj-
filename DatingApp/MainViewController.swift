//
//  ViewController.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import FlatUIKit
import Alamofire 

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let reuseIdentifier = "ContentCell"
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    
    var profile : profileView!
    var imageUploading : String!
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    @IBOutlet var barButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VC: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VC: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("VC: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("VC: viewDidDisappear")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        if let navBar = self.navigationController {
            navBar.navigationBar.barTintColor = UIColor.greenSea()
        navBar.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        let defaults = UserDefaults.standard
        let doneInitialSettings = defaults.value(forKey: "doneInitialSettings") as? String
        if (doneInitialSettings == "yes"){
            showHome()
        } else {
            defaults.setValue("yes", forKey: "doneInitialSettings")
            showSettings("yes")
        }
    
    }
    
    @IBAction func showMenuAction(_ sender: UIButton) {
        let menuVC = storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.modalPresentationStyle = .custom
        menuVC.transitioningDelegate = self
        menuVC.pvc = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender
        
        self.present(menuVC, animated: true, completion: nil)
    }
    
    func showSettings(_ first : String){
        reset()
        print("show settings executed")
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "token") as! String
        let params = ["token" : token]
        
        let nibView = Bundle.main.loadNibNamed("settingsview", owner: self, options: nil)?[0] as! settingsView
        
        nibView.frame = self.view.frame;
        self.view.addSubview(nibView)
        
        Alamofire.request(.POST, "http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/api/getuser", parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let gender = JSON.value(forKey: "gender") as! String
                    let searchdist = JSON.value(forKey: "searchdist") as! Int
                    let prefgender = JSON.value(forKey: "prefgender") as! String
                    
                    if (prefgender == "male"){
                        nibView.genderPref.isOn = true
                    } else {
                        nibView.genderPref.isOn = false
                    }
                    
                    if(gender == "male"){
                        nibView.yourGender.isOn = true
                    } else {
                        nibView.yourGender.isOn = false
                    }
                    
                    nibView.searchMiles.text = String(searchdist)
                    nibView.searchDistance.value = Float(searchdist)
                    
                }
        }

        
        nibView.pvc = self
        
        if(first == "yes"){
            nibView.isFirst = "yes"
            nibView.introLabel.isHidden = false
        } else {
            nibView.isFirst = "no"
            nibView.introLabel.isHidden = true
        }
        
       
        
        nibView.saveButton.buttonColor = UIColor.turquoise()
        nibView.saveButton.shadowColor = UIColor.greenSea()
        nibView.saveButton.shadowHeight = 3.0
        nibView.saveButton.cornerRadius = 6.0
        nibView.saveButton.titleLabel!.font = UIFont(name: "Avenir Medium", size: 20)
        nibView.saveButton.setTitleColor(UIColor.clouds(), for: UIControlState())
        nibView.saveButton.setTitleColor(UIColor.clouds(), for: UIControlState.highlighted)

        
    }
    
    func showHome(){
        reset()
        print("show settings executed")
        let nibView = Bundle.main.loadNibNamed("homeview", owner: self, options: nil)?[0] as! homeView
        nibView.frame = self.view.frame;
        self.view.addSubview(nibView)
    }
    
    func showProfile(_ first : String){
        reset()
        print("show profile executed")
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "token") as! String
        let params = ["token" : token]
        
        let nibView = Bundle.main.loadNibNamed("profileview", owner: self, options: nil)?[0] as! profileView
        nibView.frame = self.view.frame;
        self.view.addSubview(nibView)
        self.profile = nibView
        Alamofire.request(.POST, "http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/api/getuser", parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let username = JSON.value(forKey: "username") as! String
                    nibView.usernameLabel.text = username
                    
                    let photo = JSON.value(forKey: "photo") as! String
                    let photoTwo = JSON.value(forKey: "phototwo") as! String
                    let photoThree = JSON.value(forKey: "photothree") as! String
                    
                    
                    nibView.imageOne.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "ic_activity.png"),
                        options: SDWebImageOptions.refreshCached,
                        completed: { (image, data, error, bool) -> Void in
                        if image != nil {
                            nibView.imageOne.image = image
                        }
                    })
                    
                    nibView.imageTwo.sd_setImage(with: URL(string: photoTwo), placeholderImage: UIImage(named: "ic_activity.png"),
                        options: SDWebImageOptions.refreshCached,
                        completed: { (image, data, error, bool) -> Void in
                        if image != nil {
                            nibView.imageTwo.image = image
                        }
                    })
                    
                    nibView.imageThree.sd_setImage(with: URL(string: photoThree), placeholderImage: UIImage(named: "ic_activity.png"),
                        options: SDWebImageOptions.refreshCached,
                        completed: { (image, data, error, bool) -> Void in
                        if image != nil {
                            nibView.imageThree.image = image
                        }
                    })
                    
                    nibView.bioField.text = JSON.value(forKey: "bio") as! String
                }
        }
        
        
        nibView.pvc = self
        
        if(first == "yes"){
            nibView.isFirst = "yes"
            nibView.introLabel.isHidden = false
        } else {
            nibView.isFirst = "no"
            nibView.introLabel.isHidden = true
        }
        
        nibView.saveButton.buttonColor = UIColor.turquoise()
        nibView.saveButton.shadowColor = UIColor.greenSea()
        nibView.saveButton.shadowHeight = 3.0
        nibView.saveButton.cornerRadius = 6.0
        nibView.saveButton.titleLabel!.font = UIFont(name: "Avenir Medium", size: 20)
        nibView.saveButton.setTitleColor(UIColor.clouds(), for: UIControlState())
        nibView.saveButton.setTitleColor(UIColor.clouds(), for: UIControlState.highlighted)
        
        
        
    }
    
    func showChat(){
        reset()
        print("show settings executed")
        let nibView = Bundle.main.loadNibNamed("chatview", owner: self, options: nil)?[0] as! chatView
        nibView.frame = self.view.frame;
        self.view.addSubview(nibView)
    }
    
    func getPhotoBy(_ sourceType:UIImagePickerControllerSourceType){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = sourceType
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imageUpload(){
        let pickImage:UIAlertController = UIAlertController(title: "", message: "Choose the source of image", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        pickImage.addAction(UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            pickImage.dismiss(animated: true, completion: nil)
            self.getPhotoBy(UIImagePickerControllerSourceType.camera)
        }))
        
        pickImage.addAction(UIAlertAction(title: "From library", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            pickImage.dismiss(animated: true, completion: nil)
            self.getPhotoBy(UIImagePickerControllerSourceType.photoLibrary)
        }))
        
        pickImage.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            pickImage.dismiss(animated: true, completion: nil)
        }))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            pickImage.popoverPresentationController!.sourceView = self.view;
            pickImage.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height, width: 1.0, height: 1.0);
        }
        
        self.present(pickImage, animated: true, completion: nil)
    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("image picker delegate method")
        uploadToServer(image)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    func urlRequestWithComponents(_ urlString:String, parameters:Dictionary<String, String>, imageData:Data) -> (URLRequestConvertible, Data) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(url: URL(string: urlString)!)
        mutableURLRequest.httpMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
        }
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.url.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    func uploadToServer(_ image: UIImage){
        // init paramters Dictionary
        var parameters : [String:String] = ["photonumber":"one"]
        if(self.imageUploading == "one"){
            
        } else if(self.imageUploading == "two"){
            parameters = ["photonumber": "two"]
        } else if(self.imageUploading == "three"){
            parameters = ["photonumber": "three"]
        }
        
        let orImage = fixImageOrientation(image)
        let fixedImage = cropToBounds(orImage, width: 300, height: 300)
        
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "token") as! String
        
        let imageData = UIImageJPEGRepresentation(fixedImage, 0.2)
        
        
        
        // CREATE AND SEND REQUEST ----------
        
        let urlRequest = urlRequestWithComponents("http://ec2-52-49-237-143.eu-west-1.compute.amazonaws.com/api/updatephotos?token="+token, parameters: parameters, imageData: imageData!)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (JSON) in
                print(JSON)
                self.showProfile("no")
        }    

    }
    
    func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func fixImageOrientation(_ src:UIImage)->UIImage {
        
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: src.cgImage!.bitsPerComponent, bytesPerRow: 0, space: src.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func reset(){
        let container_view: UIView = self.view
        for view in container_view.subviews {
            view.removeFromSuperview()
        }
    }
    
}


extension MainViewController: UIViewControllerTransitioningDelegate {
	
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
