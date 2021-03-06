//
//  MainViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class MainViewController: UITableViewController {
    
    var demoFeatures: [DemoFeature] = []
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)

    // MARK: - View lifecycle

    func onSignIn (_ success: Bool) {
        // handle successful sign in
        if (success) {
            self.setupRightBarButtonItem()
        } else {
            // handle cancel operation from user
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRightBarButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Default theme settings.
        navigationController!.navigationBar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController!.navigationBar.barTintColor = UIColor(red: 0xF5/255.0, green: 0x85/255.0, blue: 0x35/255.0, alpha: 1.0)
        navigationController!.navigationBar.tintColor = UIColor.white

        
        var demoFeature = DemoFeature.init(
            name: NSLocalizedString("User Sign-in",
                comment: "Label for demo menu option."),
            detail: NSLocalizedString("Enable user login with popular 3rd party providers.",
                comment: "Description for demo menu option."),
            icon: "UserIdentityIcon", storyboard: "UserIdentity")
        
        demoFeatures.append(demoFeature)
        
        demoFeature = DemoFeature.init(
            name: NSLocalizedString("User Engagement",
                comment: "Label for demo menu option."),
            detail: NSLocalizedString("Analyze app usage, define segments, create and measure campaign metrics.",
            comment: "Description for demo menu option."),
            icon: "Engage", storyboard: "Engage")
        
        demoFeatures.append(demoFeature)
        
        demoFeature = DemoFeature.init(
            name: NSLocalizedString("NoSQL",
                comment: "Label for demo menu option."),
            detail: NSLocalizedString("Store data in the cloud.",
                comment: "Description for demo menu option."),
            icon: "NoSQLIcon", storyboard: "NoSQLDatabase")
        
        demoFeatures.append(demoFeature)
    }

    

    func setupRightBarButtonItem() {
            navigationItem.rightBarButtonItem = loginButton
            navigationItem.rightBarButtonItem!.target = self
            
            if (AWSSignInManager.sharedInstance().isLoggedIn) {
                navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-Out", comment: "Label for the logout button.")
                navigationItem.rightBarButtonItem!.action = #selector(MainViewController.handleLogout)
            }
            if !(AWSSignInManager.sharedInstance().isLoggedIn) {
                navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-In", comment: "Label for the login button.")
                navigationItem.rightBarButtonItem!.action = #selector(goToLogin)
            }
    }
    
    // MARK: - UITableViewController delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell")!
        let demoFeature = demoFeatures[indexPath.row]
        cell.imageView!.image = UIImage(named: demoFeature.icon)
        cell.textLabel!.text = demoFeature.displayName
        cell.detailTextLabel!.text = demoFeature.detailText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoFeatures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demoFeature = demoFeatures[indexPath.row]
        let storyboard = UIStoryboard(name: demoFeature.storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: demoFeature.storyboard)
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    
    func goToLogin() {
            print("Handling optional sign-in.")
            if !AWSSignInManager.sharedInstance().isLoggedIn {
                let config = AWSAuthUIConfiguration()
                config.enableUserPoolsUI = true
                config.canCancel = true
                
                AWSAuthUIViewController.presentViewController(with: self.navigationController!,
                                                              configuration: config,
                                                              completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                                                if error != nil {
                                                                    print("Error occurred: \(error)")
                                                                } else {
                                                                    self.onSignIn(true)
                                                                }
                })
            }
    }
    
    func handleLogout() {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
                self.setupRightBarButtonItem()
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
}

class FeatureDescriptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: nil, action: nil)
    }
}
