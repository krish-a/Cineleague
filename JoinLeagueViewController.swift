//
//  JoinLeagueViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/11/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class JoinLeagueViewController: UIViewController
{
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var joinLeagueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passTextField: UITextField!
    
    var name = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        leagueName.text = name
       
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let db = Firestore.firestore()
               
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (qs, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let la = document.get("leaguearray") as! [String]
                    if( la.count > 4 )
                    {
                        self.joinLeagueButton.isUserInteractionEnabled = false
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "You are already in 5 leagues. Leave a league to join another one"
                        self.errorLabel.textColor = UIColor.red
                    }
                    else
                    {
                        self.errorLabel.alpha = 0
                    }
                }
            }
        }
        
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (query, error) in
            if let error = error
            {
                print("FAILED: \(error)")
            }
            else
            {
                for document in query!.documents
                {
                    let pass = document.get("leaguePassword") as! String
                    if( pass == "" )
                    {
                        self.passTextField.alpha = 0
                        let constraint = NSLayoutConstraint(item: self.joinLeagueButton!, attribute: .topMargin, relatedBy: .equal, toItem: self.leagueName!, attribute: .bottomMargin, multiplier: 1.0, constant: 40)
                        self.view.addConstraint(constraint)
                    }
                    else
                    {
                        self.passTextField.alpha = 1
                        let constraint = NSLayoutConstraint(item: self.passTextField!, attribute: .topMargin, relatedBy: .equal, toItem: self.leagueName!, attribute: .bottomMargin, multiplier: 1.0, constant: 40)
                        
                        let constraint2 = NSLayoutConstraint(item: self.joinLeagueButton!, attribute: .topMargin, relatedBy: .equal, toItem: self.passTextField, attribute: .bottomMargin, multiplier: 1.0, constant: 40)
                        
                        self.view.addConstraint(constraint)
                        self.view.addConstraint(constraint2)
                    }
                }
            }
        }
        
    }
    
    @IBAction func joinLeagueButtonPressed(_ sender: Any)
    {
        let db = Firestore.firestore()
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    var usr = document.get("userArray") as! [String]
                    var usrSelect = document.get("userSelectArray") as! [String]
                    var usrwin = document.get("winsArray") as! [Int]
                    var inLeague = false
                    for i in usr
                    {
                        if( i == Auth.auth().currentUser!.uid )
                        {
                            self.errorLabel.textColor = UIColor.red
                            self.errorLabel.text = "You are already in this league"
                            self.errorLabel.alpha = 1
                            inLeague = true
                            break
                        }
                    }
                    if( inLeague == false )
                    {
                        var correctPass = true
                        let password = document.get("leaguePassword") as! String
                        if( password != "" && self.passTextField.text != password )
                        {
                            self.errorLabel.textColor = UIColor.red
                            self.errorLabel.text = "Incorrect Password"
                            self.errorLabel.alpha = 1
                            self.passTextField.text = ""
                            correctPass = false
                        }
                        if( correctPass == true )
                        {
                            self.addLeaguetoUser(leagueName: Constants.storyboard.currentLeague, useruid: Auth.auth().currentUser!.uid)
                            usr.append(Auth.auth().currentUser!.uid)
                            usrSelect.append("")
                            usrwin.append(0)
                            let x = db.collection("leagues").document(document.documentID)
                            x.updateData(["userArray":usr,"userSelectArray":usrSelect,"winsArray":usrwin]) { (error) in
                                if let error = error
                                {
                                    print("Error getting documents: \(error)")
                                }
                                else
                                {
                                    print("Sucessful")
                                }
                            }
                            self.errorLabel.textColor = UIColor.green
                            self.errorLabel.text = "You have successfully joined this league! Go back to you MyLeagues Page and hit the MyLeagues Button on top to refresh the page."
                            self.errorLabel.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    func addLeaguetoUser( leagueName: String, useruid: String)
    {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: useruid).getDocuments { (qs, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    var x = document.get("leaguearray") as! [String]
                    x.append(leagueName)
                    let y = db.collection("users").document(document.documentID)
                    y.updateData(["leaguearray":x]) { (error) in
                        if let error = error
                        {
                            print("Error getting documents: \(error)")
                        }
                        else
                        {
                            print("SUCCESSFUL!")
                        }
                    }
                }
            }
        }
    }
}
