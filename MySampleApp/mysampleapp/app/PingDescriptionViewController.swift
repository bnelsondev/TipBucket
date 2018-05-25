//
//  PingDescriptionViewController.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 11/28/17.
//

import UIKit
import AWSDynamoDB

class PingDescriptionViewController: UIViewController {
    
    var ping = UserPointAnnotation()
    var amountSelected: Int!

    @IBOutlet weak var pingNameLabel: UILabel!
    @IBOutlet weak var pingImageView: UIImageView!
    @IBOutlet weak var customDollarTextField: UITextField!
    
    @IBAction func oneDollarRadio(_ sender: Any) {
        amountSelected = 1
    }
    
    @IBAction func twoDollarsRadio(_ sender: Any) {
        amountSelected = 2
    }
    
    @IBAction func fiveDollarsRadio(_ sender: Any) {
        amountSelected = 5
    }
    
    @IBAction func customeDollarRadio(_ sender: Any) {
        if (customDollarTextField.text?.isInt)! {
            amountSelected = Int(customDollarTextField.text!)!
        }
    }
    
    @IBAction func customDollarTextField(_ sender: Any) {
        if (customDollarTextField.text?.isInt)! {
            amountSelected = Int(customDollarTextField.text!)!
        }
    }
    
    @IBAction func sendFundsButton(_ sender: Any) {
        if (amountSelected != nil) {
            addToPing(funds: amountSelected)
            let alertController = UIAlertController(title: "Success", message: "You have sent funds to \(ping.title!).", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                self.performSegue(withIdentifier: "unwindToactiveUsers", sender: self)
            })
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Input Error", message: "Please input a number.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pingNameLabel.text = ping.title!
        pingDescriptionTextView.text = "Current Ammount in Ping: $\(ping.bucketAmount!) \n\n \(ping.pingDescription!)"

        // Do any additional setup after loading the view.
    }
    
    func addToPing(funds: Int) {
        ping.bucketAmount = funds + ping.bucketAmount!
        let updatePing = convertAnnotationToPing(annotation: ping)
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDBObjectMapper.save(updatePing).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            else {
                // Do something with task.result or perform other operations.
            }
            return nil})
    }
    
    func convertAnnotationToPing(annotation: UserPointAnnotation) -> Pings {
        let ping = Pings()
        ping?._userId = annotation.userId
        ping?._pingId = annotation.pingId
        ping?._bucketAmount = annotation.bucketAmount! as NSNumber
        ping?._endDate = annotation.endDate
        ping?._endTime = annotation.endTime
        ping?._latitude = annotation.latitude! as NSNumber
        ping?._longitude = annotation.longitude! as NSNumber
        ping?._pingDescription = annotation.pingDescription
        ping?._pingName = annotation.title
        
        return ping!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

extension Int {
    var isEmpty: Bool {
        return Int(self) != nil
    }
}

//extension Int {
//    var isNil: Bool {
//        let test = Int
//    }
//}

