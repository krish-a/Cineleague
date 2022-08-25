//
//  LeagueViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/5/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class LeagueViewController: UIViewController
{
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var memberText: UILabel!
    @IBOutlet weak var membersStackView: UIStackView!
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var leaveLeagueButton: UIButton!
    @IBOutlet weak var makePicksButton: UIButton!
    @IBOutlet weak var myPicksandRankingsButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var newView: UIView!
    
    var name = ""
    
    var numArray = [1, 2, 3, 4, 5, 6, 7, 8]
    var count = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //showMembers()
        memberText.alpha = 0
        styleButtons()
        leagueName.text = name
        membersStackView.distribution = .fillEqually
        //membersStackView.spacing = 10
        membersStackView.removeArrangedSubview(label1)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func unwindLeague(_ sender: UIStoryboardSegue ){}
    
    func styleButtons()
    {
        /*let buttons = [makePicksButton, myPicksandRankingsButton, leaveLeagueButton]
        
        let blue = CGColor(srgbRed: 3/255, green: 177/255, blue: 252/255, alpha: 1)
        let green = CGColor(srgbRed: 43/255, green: 204/255, blue: 134/255, alpha: 1)
        let colors = [UIColor(cgColor: green), UIColor(cgColor: blue), UIColor.red]
        
        var c = 0
        for b in buttons
        {
            b!.backgroundColor = colors[c]
            b!.layer.cornerRadius = b!.frame.height/2
            b!.setTitleColor(UIColor.white, for: .normal)
            c += 1
        }*/
        leaveLeagueButton.backgroundColor = UIColor.red
        leaveLeagueButton.layer.cornerRadius = leaveLeagueButton.frame.height/2
        leaveLeagueButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func showMembers()
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
                    let usrs = document.get("userArray") as! [String]
                    for i in usrs
                    {
                        db.collection("users").whereField("uid", isEqualTo: i).getDocuments { (qs, err) in
                            if let err = err
                            {
                                print("Error getting documents: \(err)")
                            }
                            else
                            {
                                for document in qs!.documents
                                {
                                    let firstName = document.get("firstName") as! String
                                    
                                    let l = UILabel()
                                    l.text = "\(self.numArray[self.count]). \(firstName)"
                                    l.textColor = UIColor.black
                                    self.membersStackView.addArrangedSubview(l)
                                    let h = l.heightAnchor.constraint(equalToConstant: 40)
                                    l.addConstraint(h)
                                    
                                    self.count += 1
                                }
                            }
                            // CONFLICTING CONSTRAINT???
                            //let hc = NSLayoutConstraint(item: self.newView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(self.count*40))
                            //self.newView.addConstraint(hc)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func leaveLeagueButtonPressed(_ sender: Any)
    {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            if let error = error
            {
                print("Error getting documents: \(error)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    var leagues = document.get("leaguearray") as! [String]
                    var leagueCount = leagues.count
                    var c = 0
                    for i in leagues
                    {
                        if( i == Constants.storyboard.currentLeague )
                        {
                            leagues.remove(at: c)
                            leagueCount = leagues.count
                            break
                        }
                        c += 1
                    }

                    //update LeagueCount
                    db.collection("users").document(document.documentID).updateData(["leaguearray":leagues, "leagueCount":leagueCount])
                }
            }
        }
        
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (qs, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    var users = document.get("userArray") as! [String]
                    var userSelect = document.get("userSelectArray") as! [String]
                    var userWin = document.get("winsArray") as! [Int]
                    var d = 0
                    for j in users
                    {
                        if j == Auth.auth().currentUser!.uid
                        {
                            users.remove(at: d)
                            userSelect.remove(at: d)
                            userWin.remove(at: d)
                        }
                        d += 1
                    }

                    //remove from user select array
                    db.collection("leagues").document(document.documentID).updateData(["userArray":users, "userSelectArray":userSelect, "winsArray":userWin])
                }
            }
        }
        makePicksButton.isUserInteractionEnabled = false
    }
    
    @IBAction func makePicksButtonPressed(_ sender: Any){}
    
}
