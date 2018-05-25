//
//  LocationServicesViewController.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 11/21/17.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSDynamoDB
import CoreLocation
import MapKit


class LocationServicesViewController: UIViewController,  CLLocationManagerDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let activeUsersViewController = ActiveUsersViewController()

    @IBAction func continueButton(_ sender: Any) {
        if locationCheck() {
            appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            appDelegate.locationManager.startUpdatingLocation()
            appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
//            self.goToLogin()
            performSegue(withIdentifier: "continue", sender: self)
        }
//        //check if location services are enabled at all
//        if CLLocationManager.locationServicesEnabled() {
//            //check if location services are enabled at all
//            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
//            switch(status) {
//            //check if services disallowed for this app particularly
//            case .restricted, .denied:
//                print("No access")
//                let alertController = UIAlertController(title: "Location Access", message:
//                    "Please enable location access to use this app.", preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "Enable!", style: .default, handler: { (action: UIAlertAction!) in UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)}))
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//
//                self.present(alertController, animated: true, completion: nil)
//
//            //check if services are allowed for this app
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access! We're good to go!")
//                appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                appDelegate.locationManager.startUpdatingLocation()
//                appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
//                self.goToLogin()
//                performSegue(withIdentifier: "continue", sender: self)
//            //check if we need to ask for access
//            case .notDetermined:
//                print("asking for access...")
//                appDelegate.locationManager.requestAlwaysAuthorization()
//                appDelegate.locationManager.requestWhenInUseAuthorization()
//            }
//        }
//        //location services are disabled on the device entirely!
//        else {
//            print("Location services are not enabled")
//        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let locationEnabled = CLLocationManager.locationServicesEnabled()
//        if (locationEnabled) {
//            let skip = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activeusersnav")
//            self.present(skip, animated: true)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func enableLocation() {
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationCheck() -> Bool {
        
        var enable = false
        
        //check if location services are enabled at all
        if CLLocationManager.locationServicesEnabled() {
            //check if location services are enabled at all
            let status = CLLocationManager.authorizationStatus()
            switch(status) {
            //check if services disallowed for this app particularly
            case .restricted, .denied:
                print("No access")
                let alertController = UIAlertController(title: "Location Access", message:
                    "Please enable location access to use this app.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Enable!", style: .default, handler: { (action: UIAlertAction!) in UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)}))
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            //check if services are allowed for this app
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access! We're good to go!")
//                appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                appDelegate.locationManager.startUpdatingLocation()
//                appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
//                self.goToLogin()
//                performSegue(withIdentifier: "continue", sender: self)
                enable = true
            //check if we need to ask for access
            //should not happen
            case .notDetermined:
                print("asking for access...")
                appDelegate.locationManager.requestAlwaysAuthorization()
                appDelegate.locationManager.requestWhenInUseAuthorization()
            }
        }
            //location services are disabled on the device entirely!
        else {
            print("Location services are not enabled")
        }
        
//        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
//
//        if(status == CLAuthorizationStatus.notDetermined) {
//            appDelegate.locationManager.requestAlwaysAuthorization()
//            appDelegate.locationManager.requestWhenInUseAuthorization()
//        }
//
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
//            appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            appDelegate.locationManager.startUpdatingLocation()
//            appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
////            activeUsersViewController.scanTable()
//        }
        
        return enable
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
                                                                print("Login Success")
                                                            }
            })
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
//        let activeUsersViewController = segue.destination as? ActiveUsersViewController
//        activeUsersViewController?.scanTable()
    }
    

}
