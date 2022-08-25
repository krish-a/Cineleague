//
//  LogoutViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/10/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LogoutViewController : UIViewController
{
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var settingStackView: UIStackView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        background.backgroundColor = UIColor(red: 200/255, green: 0, blue: 0, alpha: 1)
        
        let bw = CGFloat(0.25)
        profileButton.layer.borderWidth = bw
        logoutButton.layer.borderWidth = bw
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any)
    {
        do
        {
            try Auth.auth().signOut()
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
        catch
        {
            print("ALready Logged out")
        }
        performSegue(withIdentifier: "signout", sender: self)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "personalInfo", sender: self)
    }
}
