//
//  AccountViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/6/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class AccountViewController: UIViewController
{
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpElements()
        userLogin()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func userLogin()
    {
        if( IsLoggedIn() )
        {
            print("YES")
            Auth.auth().signIn(withEmail: email(), password: password()) { (adr, err) in
                if let err = err
                {
                    print("ERROR: \(err)")
                }
                else
                {
                    let hvc = self.storyboard?.instantiateViewController(identifier: Constants.storyboard.homeviewcontroller) as? NavViewController
                    self.view.window?.rootViewController = hvc
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        else
        {
            print("NO")
        }
    }
    
    func IsLoggedIn() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func email() -> String
    {
        return UserDefaults.standard.string(forKey: "email")!
    }
    
    func password() -> String
    {
        return UserDefaults.standard.string(forKey: "password")!
    }
    
    func setUpElements()
    {
        Utilities.styleFilledButton(signUpButton, color: UIColor.white, textColor: UIColor.red)
        Utilities.styleFilledButton(loginButton, color: UIColor.white, textColor: UIColor.red)
    }
}
