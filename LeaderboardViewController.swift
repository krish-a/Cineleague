//
//  LeaderboardViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 7/6/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

class LeaderboardViewController: UIViewController
{
    @IBOutlet weak var leaderboardStackView: UIStackView!
    
    var first = true
    var count2 = 0
    var count3 = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let users = document.get("userArray") as! [String]
                    let wins = document.get("winsArray") as! [Int]
                    
                    if( self.first == true )
                    {
                        self.showLeaderboard(users: users, wins: wins)
                    }
                    self.first = false
                }
            }
        }
    }
    
    func showLeaderboard( users: [String], wins: [Int] )
    {
        var temp = wins
        var temp2 = users

        var newUsers : [String] = []
        var newWins : [Int] = []
        for _ in users
        {
            //find min number of wins
            var min = 100
            for i in temp
            {
                if( i < min )
                {
                    min = i
                }
            }
            //find who the wins belong to
            var count = 0
            for j in temp
            {
                if( j == min )
                {
                    break
                }
                count+=1
            }
            //add to new array
            newUsers.append(temp2[count])
            newWins.append(temp[count])
            //remove min win
            temp.remove(at: count)
            temp2.remove(at: count)
        }
        //print(newUsers)
        //print(newWins)
        showNames(users: newUsers, wins: newWins, c: count2)
    }
    
    func showNames( users : [String], wins: [Int], c : Int )
    {
        findName(uid: users[users.count-1-count2], users: users, wins: wins)
    }
    
    func findName( uid: String, users: [String], wins: [Int] )
    {
        let countArray = [ 1, 2, 3, 4, 5, 6, 7, 8]
        
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let name = document.get("firstName") as! String
                    
                    let rank = UIButton()
                    //let wincount = wins.count-1-count
                    rank.setTitle("\(countArray[self.count3]). \(name)", for: .normal)
                    rank.setTitleColor(UIColor.black, for: .normal)
                    rank.layer.borderWidth = 0.25
                    let height = rank.heightAnchor.constraint(equalToConstant: 60)
                    rank.addConstraint(height)
                    self.leaderboardStackView.addArrangedSubview(rank)
                    
                    self.count3+=1
                }
                self.count2+=1
                if( self.count2 <= users.count-1 )
                {
                    self.showNames(users: users, wins: wins, c: self.count2)
                }
            }
        }
    }
}
