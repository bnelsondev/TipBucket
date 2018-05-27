//
//  ActiveUsersViewController.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 10/22/17.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSDynamoDB
import AWSUserPoolsSignIn
import MapKit
import SideMenu

class ActiveUsersViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIApplicationDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userLocation = CLLocation()
    var userLocationCircle = CLLocationCoordinate2D()
    var circleRadius = CLLocationDistance(200)
    var activeUsers: [Users] = []
    var activeUsersAnnotations:[UserPointAnnotation] = []
    var currentUser: Users?
    var selectedUser: Users?
    var userExist: Bool?
    var userLoggedIn: Bool?
    var timer = Timer()
    
    @IBOutlet weak var activeUsersMap: MKMapView!
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var goOfflineButton: UIButton!
    @IBOutlet weak var onlineLabel: UILabel!
    
    @IBAction func menuButtonAction(_ sender: Any) {
    }
    
    @IBAction func goOfflineButtonAction(_ sender: Any) {
        onlineLabel.isHidden = true
        activateButton.isHidden = false
        goOfflineButton.isHidden = true
        activeUsersMap.showsUserLocation = false
        appDelegate.locationManager.stopUpdatingLocation()
        appDelegate.locationManager.allowsBackgroundLocationUpdates = false
        userOffline(user: currentUser!)
    }
    
    @IBAction func activateButtonAction(_ sender: Any) {
        if !(AWSSignInManager.sharedInstance().isLoggedIn) {
            let alertController = UIAlertController(title: "Not Logged In", message: "Please Login to Activate your Location.", preferredStyle: UIAlertControllerStyle.alert)
            let LoginAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (_)in
                //preform action here
                self.goToLogin()
            })
            alertController.addAction(LoginAction)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            onlineLabel.isHidden = false
            activateButton.isHidden = true
            goOfflineButton.isHidden = false
            activeUsersMap.showsUserLocation = true
            appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            appDelegate.locationManager.startUpdatingLocation()
            appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
            appDelegate.locationManager.allowsBackgroundLocationUpdates = true
            checkUser()
            checkAndAddUser()
        }
    }
    
    @IBAction func unwindToActiveUsers(segue: UIStoryboardSegue){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        setup()
        checkUser()
        scanTable()
        loadTransactions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateButton.layer.masksToBounds = true
        activateButton.layer.cornerRadius = activateButton.frame.width/2
        
//        self.setupRightBarButtonItem()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Default theme settings.
//        navigationController!.navigationBar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        navigationController!.navigationBar.barTintColor = UIColor(red: 0xF5/255.0, green: 0x85/255.0, blue: 0x35/255.0, alpha: 1.0)
//        navigationController!.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
        
        timer = Timer(timeInterval: 10.0, target: self, selector: #selector(ActiveUsersViewController.refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refresh() {
        self.UI {
            self.scanTable()
            self.loadTransactions()
        }
        print("Map Refreshed")
        print("Transactions Refreshed")
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
    
    func handleLogout() {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,appDelegate.regionRadius, appDelegate.regionRadius)
        activeUsersMap.setRegion(coordinateRegion, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "user"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        pinView!.image = UIImage(named: "Pin")

        let btn = UIButton(type: .detailDisclosure)
        pinView?.rightCalloutAccessoryView = btn

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if !(AWSSignInManager.sharedInstance().isLoggedIn) {
                let alertController = UIAlertController(title: "Not Logged In", message: "Please Login to view active users.", preferredStyle: UIAlertControllerStyle.alert)
                let LoginAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (_)in
                    //preform action here
                    self.goToLogin()
                })
                alertController.addAction(LoginAction)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "showuser", sender: Any?.self)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var selectedAnnotation = false
        
        if let _ = view.annotation as? UserPointAnnotation {
            selectedAnnotation = true
        }
        
        if (selectedAnnotation) {
//            selectedUser = view.annotation as! UserPointAnnotation
            
            let userAnnotation = view.annotation as? UserPointAnnotation
            let user = Users()
            user?._userId = userAnnotation?.userId
            user?._userName = userAnnotation?.title
            user?._active = userAnnotation?.active as NSNumber?
            user?._cash = userAnnotation?.cash as NSNumber?
            user?._latitude = userAnnotation?.latitude as NSNumber?
            user?._longitude = userAnnotation?.longitude as NSNumber?
            
            selectedUser = user
        }
    }
    
    func setup() {
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined) {
            appDelegate.locationManager.requestAlwaysAuthorization()
            appDelegate.locationManager.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            appDelegate.locationManager.startUpdatingLocation()
            appDelegate.sourceLocation = appDelegate.locationManager?.location?.coordinate
            setUserLocation()
        }
    }
    
    func checkAndAddUser() {
        if !userExist! {
            addUser()
        }
        else {
            userOnline(user: currentUser!)
        }
    }
    
    func checkUser() {
        let userId = AWSIdentityManager.default().identityId
//        let userName = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username
        
        if (userId == nil) {
            print("No User Logged In!")
            userLoggedIn = false
            return
        }
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "contains(#userId, :userId)"
        scanExpression.expressionAttributeNames  = [
            "#userId": "userId"
        ]
        scanExpression.expressionAttributeValues = [
            ":userId": userId!
        ]
        //        scanExpression.limit = 20
        
        dynamoDBObjectMapper.scan(Users.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            
            if (task.result?.items.isEmpty)! {
                self.userExist = false
                print("User Doesn't Exist")
            }
            
            if let paginatedOutput = task.result {
                if (paginatedOutput.items as? [Users] == nil) {
                    self.userExist = false
                    print("User Doesn't Exist")
                }
                for user in paginatedOutput.items as! [Users] {
                    if (user._userId! == userId) {
                        self.currentUser = user
                        self.userExist = true
                        print("User \(user._userId!) Exist")
                    }
                }
            }
            return nil})
    }
    
    func addUser() {
        
        let user = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username
        let userID = AWSIdentityManager.default().identityId
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let usersItem: Users = Users()
        
        usersItem._userId = userID
        usersItem._userName = user
        usersItem._cash = 0
        usersItem._active = true
        usersItem._latitude = appDelegate.sourceLocation?.latitude as NSNumber?
        usersItem._longitude = appDelegate.sourceLocation?.longitude as NSNumber?
        
        //Save a new item
        dynamoDbObjectMapper.save(usersItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User saved.")
        })
    }
    
    func userOnline(user: Users) {
        user._active = true
        user._latitude = appDelegate.sourceLocation?.latitude as NSNumber?
        user._longitude = appDelegate.sourceLocation?.longitude as NSNumber?
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.save(user, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User Online.")
        })
    }
    
    func userOffline (user: Users) {
        user._active = false
        user._latitude = appDelegate.sourceLocation?.latitude as NSNumber?
        user._longitude = appDelegate.sourceLocation?.longitude as NSNumber?
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()

        dynamoDbObjectMapper.save(user, completionHandler: {
            (error: Error?) -> Void in

            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User Offline.")
        })
    }
    
    func setUserLocation() {
        userLocation = CLLocation(latitude: (appDelegate.sourceLocation?.latitude)!, longitude: (appDelegate.sourceLocation?.longitude)!)
        centerMapOnLocation(location: userLocation)
    }
    
    func scanTable() {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let userId = AWSIdentityManager.default().identityId
        let scanExpression = AWSDynamoDBScanExpression()
        //        scanExpression.limit = 20

        var loadedAnnotations:[UserPointAnnotation] = []
        var loadedUsers: [Users] = []
        
        dynamoDBObjectMapper.scan(Users.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for user in paginatedOutput.items as! [Users] {
                    let userLocation = CLLocation(latitude: (user._latitude! as? Double)!, longitude: (user._longitude! as? Double)!)
                    let distance: CLLocationDistance = self.userLocation.distance(from: userLocation)
                    if !(user._userId == userId) {
                        if (distance <= self.circleRadius && (user._active as? Bool)!) {
//                            if !(self.activeUsers.contains(user)) {
                                loadedUsers.append(user)
                                let userAnnotation = UserPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: (Double((user._latitude! as? Double)!)), longitude: (Double((user._longitude! as? Double)!))), title: (user._userName!))
                                userAnnotation.userId = (user._userId!)
                                userAnnotation.cash = (Int((user._cash! as? Int)!))
                                userAnnotation.latitude = (Double((user._latitude! as? Double)!))
                                userAnnotation.longitude = (Double((user._longitude! as? Double)!))
                                userAnnotation.active = (Int((user._active! as? Int)!))
                                loadedAnnotations.append(userAnnotation)
                                print("User \(user._userId!) Copied")
//                            }
                        }
                    }
                }
                self.UI {
                    if !(self.activeUsersAnnotations == loadedAnnotations) {
                        self.activeUsersMap.removeAnnotations(self.activeUsersAnnotations)
                        self.activeUsersAnnotations = loadedAnnotations
                        self.activeUsers = loadedUsers
                        self.activeUsersMap.addAnnotations(self.activeUsersAnnotations)
                        self.activeUsersMap.reloadInputViews()
                        print("Map Updated")
                    }
                }
            }
            return nil})
    }
    
    func loadTransactions() {
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let userId = AWSIdentityManager.default().identityId
        let scanExpression = AWSDynamoDBScanExpression()
        
        var loadedTransactions: [Transactions] = []
        
        if userId == nil{
            print("No User Logged In! Can't Load Transactions.")
            userLoggedIn = false
            return
        }
        
        scanExpression.filterExpression = "contains(#userId, :userId)"
        scanExpression.expressionAttributeNames  = [
            "#userId": "userId"
        ]
        scanExpression.expressionAttributeValues = [
            ":userId": userId!
        ]
        //        scanExpression.limit = 20
        
        dynamoDBObjectMapper.scan(Transactions.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for transaction in paginatedOutput.items as! [Transactions] {
                    loadedTransactions.append(transaction)
                }
                self.UI {
                    if !(self.appDelegate.transactions == loadedTransactions) {
                        self.appDelegate.transactions = loadedTransactions
                        print("Transactions Updated")
                    }
                }
            }
            return nil})
    }


    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
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
        if (segue.identifier == "showuser"){
            let vc = segue.destination as! UserDescriptionViewController
            vc.selectedUser = selectedUser!
            vc.currentUser = currentUser!
            print("User Copied to VC")
        }
        
        if (segue.identifier == "openMenu") {
        }
    }

}
