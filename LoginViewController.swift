//
//  LoginViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/6/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        //Utilities.styleTextField(emailTextField)
        //Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton, color: UIColor.white, textColor: UIColor.red)
    }
    
    @IBAction func loginTapped(_ sender: Any)
    {
        // Validate text fields
        
        // create cleaned text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil
            {
                // Could not sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else
            {
                // signed in successfully
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                
                let hvc = self.storyboard?.instantiateViewController(identifier: Constants.storyboard.homeviewcontroller) as? NavViewController
                self.view.window?.rootViewController = hvc
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
