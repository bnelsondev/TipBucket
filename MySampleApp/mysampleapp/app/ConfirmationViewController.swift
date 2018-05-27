//
//  ConfirmationViewController.swift
//  TipBucket
//
//  Created by Bryan Nelson on 5/27/18.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    var message: String?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func okButton(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToActiveUsers", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageLabel.sizeToFit()
        messageLabel.text = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
