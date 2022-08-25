//
//  PersonalInfoViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 7/11/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class PersonalInfoViewController: UIViewController
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Utilities.styleTextField(firstNameTextField)
        //Utilities.styleTextField(lastNameTextField)
        //Utilities.styleTextField(usernameTextField)
        getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getInfo()
    {
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let firstName = document.get("firstName") as! String
                    let lastName = document.get("lastName") as! String
                    
                    self.firstNameTextField.text = firstName
                    self.lastNameTextField.text = lastName
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let x = db.collection("users").document(document.documentID)
                    x.updateData(["firstName": self.firstNameTextField.text, "lastName": self.lastNameTextField.text])
                }
            }
        }
    }
}
