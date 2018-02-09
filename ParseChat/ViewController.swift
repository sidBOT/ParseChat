//
//  ViewController.swift
//  ParseChat
//
//  Created by siddhant on 2/8/18.
//  Copyright © 2018 siddhant. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func is_alertViewMessage() {
        let alertController = UIAlertController(title: "Error", message: "Username/Password cannot be empty", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
    }
    
    func errorAlertView(error: Error!) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)

    }

    @IBAction func loginAction(_ sender: Any) {
        let username = emailField.text ?? ""
        let password = passField.text ?? ""
        
        
        if(!(emailField.text?.isEmpty)! && !(passField.text?.isEmpty)!) {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                    self.errorAlertView(error: error)
                } else {
                    print("User logged in successfully")
                    // display view controller that needs to shown after successful login
                }
            }
        }else {
            is_alertViewMessage()
        }
    }

    @IBAction func registerAction(_ sender: Any) {
        let newUser = PFUser()
        
        // set user properties
        newUser.username = emailField.text
        newUser.password = passField.text
        
        // call sign up function on the object
        if(!(emailField.text?.isEmpty)! && !(passField.text?.isEmpty)!) {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorAlertView(error: error)
                } else {
                    print("User Registered successfully")
                    // manually segue to logged in view
                }
            }
        }else {
            is_alertViewMessage()
        }
    }
}

