//
//  MakeLeagueViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 4/16/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class MakeLeagueViewController: UIViewController
{
    @IBOutlet weak var leagueNameText: UITextField!      // username textfield
    @IBOutlet weak var leaguePasswordText: UITextField!  // password textfield
    @IBOutlet weak var pass: UILabel!                   // password label
    
    @IBOutlet weak var privateSwitch: UISwitch! // private league switch
    @IBOutlet weak var submitButton: UIButton!   // submit button
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var user = false
    
    //var leaguearray : [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        // making submit button round
        submitButton.backgroundColor = UIColor.red
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.isUserInteractionEnabled = false
    }
    
    // show league on my leagues page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let x = League()
        x.setusername(user: leagueNameText.text!)
        if( privateSwitch.isOn )
        {
            x.setpassword(pass: leaguePasswordText.text!)
        }
        let vc = segue.destination as! FirstViewController
        
        let db = Firestore.firestore()
        //leaguearray.append(x.getusername())
        //leaguearray.append(x.getpassword())
        let userArray : [String] = [Auth.auth().currentUser!.uid]
        let userSelectArray : [String] = [""]
        let winsArray : [Int] = [0]
        db.collection("leagues").addDocument(data: ["leagueName": x.getusername(), "leaguePassword": x.getpassword(), "userArray":userArray, "userSelectArray": userSelectArray, "winsArray": winsArray])
        
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    var c = document.get("leaguearray") as! [String]
                    c.append(x.getusername())
                    let d = db.collection("users").document(document.documentID)
                    d.updateData(["leaguearray":c]) { (error) in
                        if let err = err
                        {
                             print("Error updating document: \(err)")
                        }
                        else
                        {
                            print("Document successfully updated!!!")
                            vc.showLeagues()
                        }
                    }
                }
            }
        }
        
        //vc.finalleaguearray.append(x)
        vc.count = vc.count+1
        //vc.showLeagues()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any){}
    

    @IBAction func nameTyped(_ sender: UITextField)
    {
        let x = leagueNameText.text!
        if( x.trimmingCharacters(in: .whitespaces) != "" )
        {
            if( x.count > 15 )
            {
                errorLabel.alpha = 1
                errorLabel.text = "This name is too long"
                user = false
                submitButton.isUserInteractionEnabled = false
            }
            else if( x.count < 3 )
            {
                errorLabel.alpha = 1
                errorLabel.text = "This name is too short"
                user = false
                submitButton.isUserInteractionEnabled = false
            }
            else
            {
                errorLabel.alpha = 0
                //user = true
                nameTaken(name: leagueNameText.text!)
                //passTyped(leaguePasswordText)
            }
        }
        else
        {
            user = false
            submitButton.isUserInteractionEnabled = false
        }
    }
    
    func nameTaken( name: String )
    {
        let db = Firestore.firestore()
        db.collection("leagues").getDocuments { (qsnap, er) in
            if let er = er
            {
                print( "ERROR: \(er)" )
            }
            else
            {
                var taken = false
                for document in qsnap!.documents
                {
                    let leagueName = document.get("leagueName") as! String
                    if( leagueName == name )
                    {
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "This name is already taken"
                        self.submitButton.isUserInteractionEnabled = false
                        taken = true
                        break
                    }
                }
                if( taken == false )
                {
                    self.user = true
                    if( self.privateSwitch.isOn == false )
                    {
                        self.submitButton.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.passTyped(self.leaguePasswordText)
                    }
                }
                else
                {
                    self.user = false
                }
            }
        }
    }
    
    @IBAction func passTyped(_ sender: UITextField)
    {
        let y = leaguePasswordText.text!
        if( privateSwitch.isOn && y.trimmingCharacters(in: .whitespaces) == "" )
        {
            submitButton.isUserInteractionEnabled = false
        }
        else if( user == true )
        {
            submitButton.isUserInteractionEnabled = true
        }
    }
    
    
    // hide password or show password
    @IBAction func privateLeagueChosen(_ sender: UISwitch)
    {
        if( sender.isOn == true )
        {
            pass.alpha = 1
            leaguePasswordText.alpha = 1
            /*pass.textColor = UIColor.black
            leaguePasswordText.layer.borderColor = UIColor.gray.cgColor
            leaguePasswordText.textColor = UIColor.black;
            leaguePasswordText.layer.borderWidth = 1.0
            leaguePasswordText.isUserInteractionEnabled = true*/
        }
        else
        {
            pass.alpha = 0
            leaguePasswordText.alpha = 0
            
            /*pass.textColor = UIColor.white
            leaguePasswordText.layer.borderColor = UIColor.white.cgColor
            leaguePasswordText.textColor = UIColor.white;
            leaguePasswordText.layer.borderWidth = 1.0
            leaguePasswordText.isUserInteractionEnabled = false*/
            
            let z = leagueNameText.text!
            if( z.trimmingCharacters(in: .whitespaces) != "" )
            {
                nameTyped(leagueNameText)
                //submitButton.isUserInteractionEnabled = true
            }
        }
    }
    
}
