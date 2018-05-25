////
////  SendPingViewController.swift
////  MySampleApp
////
////  Created by Bryan Nelson on 10/29/17.
////
//
//import UIKit
//import MapKit
//import AWSAuthCore
//
//class SendPingViewController: UIViewController, MKMapViewDelegate {
// 
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var insertPing: [String:Any] = [:]
//    let pingDate = DateFormatter()
//    let pingTime = DateFormatter()
//    
//    @IBOutlet weak var sendPingsMapKit: MKMapView!
//    @IBOutlet weak var sendPingDatePicker: UIDatePicker!
//    
//    @IBAction func unwindToSendPing(segue: UIStoryboardSegue){
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        sendPingsMapKit.delegate = self
//        let userLocation = CLLocation(latitude: (appDelegate.sourceLocation?.latitude)!, longitude: (appDelegate.sourceLocation?.longitude)!)
//        centerMapOnLocation(location: userLocation)
//
//        // Do any additional setup after loading the view.
//    }
//    
//    @IBAction func sendPingDatePickerChanged(_ sender: UIDatePicker) {
//    }
//    
//    @IBAction func nextButton(_ sender: Any) {
//        pingDate.dateFormat = "MM/dd/yyyy"
//        pingTime.dateFormat = "HH:mm"
//        
//        let identityManager = AWSIdentityManager.default()
//        let uuid = UUID().uuidString
//        
//        insertPing["userId"] = identityManager.identityId
//        insertPing["pingId"] = uuid
//        insertPing["bucketAmount"] = 0
//        insertPing["endDate"] = pingDate.string(from: sendPingDatePicker.date)
//        insertPing["endTime"] = pingTime.string(from: sendPingDatePicker.date)
//        insertPing["latitude"] = (appDelegate.sourceLocation?.latitude)!
//        insertPing["longitude"] = (appDelegate.sourceLocation?.longitude)!
//    }
//    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  appDelegate.regionRadius, appDelegate.regionRadius)
//        sendPingsMapKit.setRegion(coordinateRegion, animated: false)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first{
//            print(location.coordinate)
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sendPingNext"{
//            let vc = segue.destination as! SendPingDescriptionViewController
//            vc.insertPing = insertPing
//            for (myKey,myValue) in vc.insertPing {
//                print("\(myKey) \t \(myValue)")
//            }
//        }
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//
//}

