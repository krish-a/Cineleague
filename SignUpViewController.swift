//
//  SignUpViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/6/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
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
        
        //navigationController?.navigationBar.tintColor = UIColor.white
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        /*Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)*/
        Utilities.styleFilledButton(signUpButton, color: UIColor(red: 95/255, green: 176/255, blue: 255/255, alpha: 1), textColor: UIColor.white)
    }
    
    // Check fields and validate if data is correct
    // If evertyhing is correct, returns nil, otherwise returns error message
    func validateFields() -> String?
    {
        // Check if all fields are filled
        if( firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" )
        {
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if( Utilities.isPasswordValid(cleanedPassword) == false )
        {
            return "Please make sure your password is atleast 8 characters, contains a special character, and a number"
        }
        
        return nil
    }
    
    func showError(_ message : String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func signUpTapped(_ sender: Any)
    {
        // validate the fields
        let error = validateFields()
        if( error != nil )
        {
            showError(error!)
        }
        else
        {
            // create cleaned data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil
                {
                    self.showError("Error creating user")
                }
                else
                {
                    let db = Firestore.firestore()
                    
                    let leaguearray : [String] = []
                    //, "league1":"a", "league2":"a", "league3":"a"
                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid":result!.user.uid, "leaguearray":leaguearray]) { (error) in
                        
                        if err != nil
                        {
                            // show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(password, forKey: "password")
                    UserDefaults.standard.synchronize()
                    
                    // transition to the home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome()
    {
        let hvc = storyboard?.instantiateViewController(identifier: Constants.storyboard.homeviewcontroller) as? NavViewController
        view.window?.rootViewController = hvc
        view.window?.makeKeyAndVisible()
    }
}
