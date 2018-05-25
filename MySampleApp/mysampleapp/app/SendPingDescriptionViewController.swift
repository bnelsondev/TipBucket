////
////  SendPingDescriptionViewController.swift
////  MySampleApp
////
////  Created by Bryan Nelson on 10/29/17.
////
//
//import UIKit
//import AWSDynamoDB
//
//class SendPingDescriptionViewController: UIViewController {
//    
//    var insertPing = [String: Any]()
//
//    @IBOutlet weak var sendPingDescriptionScrollView: UIScrollView!
//    @IBOutlet weak var sendPingNameTextField: UITextField!
//    @IBOutlet weak var sendPingDescriptionTextView: UITextView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
//
//        
//        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
//        sendPingDescriptionTextView.layer.borderWidth = 1.0
//        sendPingDescriptionTextView.layer.borderColor = borderColor.cgColor
//        sendPingDescriptionTextView.layer.cornerRadius = 5.0
//
//        // Do any additional setup after loading the view.
//    }
//    
//    @IBAction func sendPingButton(_ sender: Any) {
//        let pingName = sendPingNameTextField.text
//        let pingDescription = sendPingDescriptionTextView.text
//        if ((pingName?.isEmpty)! && (pingDescription?.isEmpty)!) {
//            let alertController = UIAlertController(title: "Input Error", message: "Please input a name and description..", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            
//            self.present(alertController, animated: true, completion: nil)
//            
//        }else if (pingName?.isEmpty)! {
//            let alertController = UIAlertController(title: "Input Error", message: "Please input a name.", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            
//            self.present(alertController, animated: true, completion: nil)
//            
//        } else if (pingDescription?.isEmpty)! {
//            let alertController = UIAlertController(title: "Input Error", message: "Please input a description.", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            
//            self.present(alertController, animated: true, completion: nil)
//            
//        } else {
//            savePing()
//            let alertController = UIAlertController(title: "Success", message: "You have create a new ping!", preferredStyle: UIAlertControllerStyle.alert)
//            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                (_)in
//                self.performSegue(withIdentifier: "unwindToSendPing", sender: self)
//            })
//            alertController.addAction(OKAction)
//            
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//    
//    @objc func adjustForKeyboard(notification: Notification) {
//        let userInfo = notification.userInfo!
//        
//        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//        
//        if notification.name == Notification.Name.UIKeyboardWillHide {
//            sendPingDescriptionScrollView.contentInset = UIEdgeInsets.zero
//        } else {
//            sendPingDescriptionScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
//        }
//        
//        sendPingDescriptionScrollView.scrollIndicatorInsets = sendPingDescriptionScrollView.contentInset
//    }
//    
//    func savePing() {
//        insertPing["pingName"] = sendPingNameTextField.text
//        insertPing["pingDescription"] = sendPingDescriptionTextView.text
//        for (myKey,myValue) in insertPing {
//            print("\(myKey) \t \(myValue)")
//        }
//        
//        let userId = insertPing["userId"] as? String
//        let pingId = insertPing["pingId"] as? String
//        let bucketAmount = insertPing["bucketAmount"] as? NSNumber
//        let endDate = insertPing["endDate"] as? String
//        let endTime = insertPing["endTime"] as? String
//        let latitude = insertPing["latitude"] as? NSNumber
//        let longitude = insertPing["longitude"] as? NSNumber
//        let pingDescription = insertPing["pingDescription"] as? String
//        let pingName = insertPing["pingName"] as? String
//        
//        let myPing = Pings()
//        myPing?._userId = userId
//        myPing?._pingId = pingId
//        myPing?._bucketAmount = bucketAmount
//        myPing?._endDate = endDate
//        myPing?._endTime = endTime
//        myPing?._latitude = latitude
//        myPing?._longitude = longitude
//        myPing?._pingDescription = pingDescription
//        myPing?._pingName = pingName
//        
//        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
//        
//        dynamoDBObjectMapper.save((myPing)!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//            }
//            else {
//                // Do something with task.result or perform other operations.
//            }
//            return nil})
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

