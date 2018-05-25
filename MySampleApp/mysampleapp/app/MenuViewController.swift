//
//  MenuViewController.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 12/13/17.
//

import UIKit
import AWSAuthUI
import AWSAuthCore
import SideMenu

class MenuViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let activeUsersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activeusers") as! ActiveUsersViewController
    
    var transactions:[Transactions]?
    
    @IBOutlet weak var signinButton: UIButton!
    
    @IBAction func signinButtonAction(_ sender: Any) {
        
        if !(AWSSignInManager.sharedInstance().isLoggedIn) {
            goToLogin()
        } else if (AWSSignInManager.sharedInstance().isLoggedIn) {
            handleLogout()
            dismiss(animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupLoginButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setupLoginButton()

        // Do any additional setup after loading the view.
    }
    
    func setupLoginButton() {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            signinButton.setTitle("Sign-Out", for: .normal)
        }
        if !(AWSSignInManager.sharedInstance().isLoggedIn) {
           signinButton!.setTitle("Sign-In", for: .normal)
        }
    }
    
    func onSignIn (_ success: Bool) {
        // handle successful sign in
        if (success) {
            self.setupLoginButton()
        } else {
            // handle cancel operation from user
        }
    }
    
    func goToLogin() {
        print("Handling optional sign-in.")
        if !AWSSignInManager.sharedInstance().isLoggedIn {

            let config = AWSAuthUIConfiguration()
            config.enableUserPoolsUI = true
            config.canCancel = true
            
            AWSAuthUIViewController.presentViewController(with: navigationController!,
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
                self.setupLoginButton()
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
