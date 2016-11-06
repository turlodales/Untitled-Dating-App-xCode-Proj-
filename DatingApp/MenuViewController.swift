//
//  MenuViewController.swift
//  GuillotineMenuExample
//
//  Created by Maksym Lazebnyi on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit



class MenuViewController: UIViewController, GuillotineMenu {
    //GuillotineMenu protocol
    var dismissButton: UIButton!
    var titleLabel: UILabel!
    var pvc: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = UIButton(frame: CGRect.zero)
        dismissButton.setImage(UIImage(named: "ic_menu"), for: UIControlState())
        dismissButton.addTarget(self, action: #selector(MenuViewController.dismissButtonTapped(_:)), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1;
        //titleLabel.text = "Home"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }
    
    func dismissButtonTapped(_ sende: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func settingsButton(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.pvc.showSettings("no")
    }
    
    @IBAction func profileButton(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.pvc.showProfile("no")

    }
    @IBAction func chatsButton(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.pvc.showChat()

    }
    @IBAction func homeButton(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.pvc.showHome()
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension MenuViewController: GuillotineAnimationDelegate {
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
