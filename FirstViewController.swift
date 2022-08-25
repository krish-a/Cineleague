//
//  FirstViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 4/15/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class FirstViewController: UIViewController
{
    @IBOutlet weak var leagueStackView: UIStackView! // stack view of all leagues
    @IBOutlet weak var myLeaguesButton: UIButton!
    
    @IBOutlet weak var button1: UIButton!           // first league
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBOutlet weak var background: UIImageView!
    
    var count = 0
    
    //var finalleaguearray : [League] = []  // array with username and password of all leagues
    //var finalleaguearray1 : [League] = []

    @IBOutlet weak var plus: UIButton!      // plus button
    
    var buttonarray2 : [UIButton] = []
    var league = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        showLeagues()
        
        background.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 200/255, green: 0, blue: 0, alpha: 1))
        myLeaguesButton.setTitleColor(UIColor.white, for: .normal)
        plus.setTitleColor(UIColor.white, for: .normal)
        
        buttonarray2 = [button1, button2, button3, button4, button5]
        for i in buttonarray2
        {
            i.addTarget(self, action: #selector(leaguePressed(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        showLeagues()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func myLeagueButtonPressed(_ sender: Any)
    {
        showLeagues()
    }
    
    @IBAction func leaguePressed(_ sender: UIButton)
    {
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let arrayleagues = document.get("leaguearray") as! [String]
                    for lg in arrayleagues
                    {
                        if( "   \(lg) League" == sender.titleLabel?.text )
                        {
                            self.league = lg
                            Constants.storyboard.currentLeague = lg
                            self.performSegue(withIdentifier: "accessLeagueSegue", sender: self)
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if( segue.identifier == "accessLeagueSegue")
        {
            let vc = segue.destination as! LeagueViewController
            vc.name = "\(league) League"
        }
    }
    
     // go to create league plage when + clicked
    @IBAction func plusbuttonpressed(_ sender: Any)
    {
        if( count > 4 )
        {
            plus.isUserInteractionEnabled = false
        }
        else
        {
            self.performSegue(withIdentifier: "makeLeagueSegue", sender: self)
        }
    }

    // go back to leagues page
    @IBAction func unwindToMakeLeague(_ sender: UIStoryboardSegue )
    {
        showLeagues()
    }
    
    func makeLeagueButton( button : UIButton, title : String )
    {
        let borderwidth = CGFloat(0.25)
        
        button.setTitle("   \(title) League", for: .normal)
        button.layer.borderWidth = borderwidth
        //button.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
    
    func showLeagues()
    {
        //print("SHOW LEAGUES")
        for i in buttonarray2
        {
            i.setTitle("", for: .normal)
            i.layer.borderWidth = 0
        }
        
        let db = Firestore.firestore()

        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let arrayleagues = document.get("leaguearray") as! [String]
                    print(arrayleagues.count)
                    var c = 0
                    for lg in arrayleagues
                    {
                        self.makeLeagueButton(button: self.buttonarray2[c], title: lg)
                        c += 1
                    }
                    let d = db.collection("users").document(document.documentID)
                    d.updateData(["leagueCount":arrayleagues.count]) { (err) in
                        if let err = err
                        {
                             print("Error updating document: \(err)")
                        }
                        else
                        {
                            print("Document successfully updated!!!")
                        }
                    }
                    if( arrayleagues.count >= 5 )
                    {
                        self.plus.isUserInteractionEnabled = false
                    }
                    else
                    {
                        self.plus.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}
