//
//  UserDescriptionViewController.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 11/28/17.
//

import UIKit
import AWSDynamoDB

class UserDescriptionViewController: UIViewController, UITextFieldDelegate {
    
    var selectedUser = Users()!
    var currentUser = Users()!
    var transactionSpend = Transactions()!
    var transactionReceive = Transactions()!
    var amountSelected: Int!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var customDollarTextField: UITextField!
    @IBOutlet weak var subView: UIView!
    
    @IBAction func oneDollarRadio(_ sender: Any) {
        customDollarTextField.isHidden = true
        amountSelected = 1
    }
    
    @IBAction func twoDollarsRadio(_ sender: Any) {
        customDollarTextField.isHidden = true
        amountSelected = 2
    }
    
    @IBAction func fiveDollarsRadio(_ sender: Any) {
        customDollarTextField.isHidden = true
        amountSelected = 5
    }
    
    @IBAction func customDollarRadio(_ sender: Any) {
        customDollarTextField.isHidden = false
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
        if (customDollarTextField.text?.isInt)! {
            amountSelected = Int(customDollarTextField.text!)!
        }
        if (amountSelected == nil) {
            let alertController = UIAlertController(title: "Input Error", message: "Please input a number.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))

            self.present(alertController, animated: true, completion: nil)
        } else {
            addToUser(funds: amountSelected)
            self.performSegue(withIdentifier: "confirmation", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = selectedUser._userName

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -190, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -190, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        customDollarTextField.resignFirstResponder()
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.2
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func addToUser(funds: Int) {
        
        var selectedUserCash = selectedUser._cash as! Int
        selectedUserCash = funds + selectedUserCash
        selectedUser._cash = selectedUserCash as NSNumber
        
        var currentUserCash = currentUser._cash as! Int
        currentUserCash = (-funds) + currentUserCash
        currentUser._cash = currentUserCash as NSNumber
        
//        transactionSpend._transactionId = NoSQLSampleDataGenerator.randomSampleNumber()
        transactionSpend._transactionId = UUID().uuidString
        transactionSpend._userId = currentUser._userId
        transactionSpend._userName = currentUser._userName
        transactionSpend._otherUserName = selectedUser._userName
        transactionSpend._amount = -funds as NSNumber
        
        transactionReceive._transactionId = UUID().uuidString
        transactionReceive._userId = selectedUser._userId
        transactionReceive._userName = selectedUser._userName
        transactionReceive._otherUserName = currentUser._userName
        transactionReceive._amount = funds as NSNumber
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDBObjectMapper.save(selectedUser).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            else {
                // Do something with task.result or perform other operations.
            }
            return nil})
        
        dynamoDBObjectMapper.save(currentUser).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            else {
                // Do something with task.result or perform other operations.
            }
            return nil})
        
        dynamoDBObjectMapper.save(transactionSpend).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            else {
                // Do something with task.result or perform other operations.
            }
            return nil})
        
        dynamoDBObjectMapper.save(transactionReceive).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            }
            else {
                // Do something with task.result or perform other operations.
            }
            return nil})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmationViewController
        vc.message = "You have sent $\(amountSelected!) to \(selectedUser._userName!)."
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

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

