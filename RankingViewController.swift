//
//  RankingViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/14/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class RankingViewController: UIViewController
{
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    
    @IBOutlet weak var totalEarnings: UILabel!
    var revenueArray : [Int] = []
    var revenue = 0
    
    @IBOutlet weak var rankingsStackView: UIStackView!
    @IBOutlet weak var stackView1: UIStackView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var rankingsLabel: UILabel!
    
    @IBOutlet weak var newView: UIView!
    
    var first = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        let rightnow = Date()
        let cfromrn = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: rightnow)
        
        rankingsStackView.removeArrangedSubview(stackView1)
        stackView1.removeFromSuperview()
        showMovies()
        
        let db = Firestore.firestore()
        db.collection("movies").getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    var r = document.get("bo") as! Double
                    r *= 1000000
                    let rint = Int(r)
                    self.revenueArray.append(rint)
                }
            }
        }
        
        //if( cfromrn.weekday! == 1 || cfromrn.weekday! > 5 )
        if( true )
        {
            errorLabel.alpha = 0
            rankingsLabel.alpha = 1
            totalEarnings.alpha = 1
            showRankings()
        }
        else
        {
            errorLabel.alpha = 1
            rankingsLabel.alpha = 0
            totalEarnings.alpha = 0
            let hc = NSLayoutConstraint(item: newView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            newView.addConstraint(hc)
        }
    }
    
    func addRevenue( str: String )
    {
        let x = Int(str)!
        //revenue = revenue + Constants.movies.weekonebo[x-1]
        revenue = revenue + revenueArray[x-1]
        
        let z = revenue as NSNumber
        let y = NumberFormatter.localizedString(from: z, number: NumberFormatter.Style.decimal)
        
        totalEarnings.text = "Total Revenue: $\(y)"
    }
    
    func showMovies()
    {
        let images = [image1, image2, image3, image4, image5, image6, image7, image8]
        
        let db = Firestore.firestore()
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (querysnapshot, err) in
            if let err = err
            {
                print("Not Succesful, error: \(err)")
            }
            else
            {
                for document in querysnapshot!.documents
                {
                    let users = document.get("userArray") as! [String]
                    let userSelect = document.get("userSelectArray") as! [String]
                    var count = 0
                    for i in users
                    {
                        if i == Auth.auth().currentUser!.uid
                        {
                            var c = 0
                            for j in userSelect[count]
                            {
                                images[c]?.image = UIImage(named: "\(j)")
                                self.addRevenue(str: "\(j)")
                                c += 1
                            }
                            break
                        }
                        count += 1
                    }
                }
            }
        }
    }
    
    func showRankings()
    {
        let db = Firestore.firestore()
        db.collection("leagues").whereField("leagueName", isEqualTo: Constants.storyboard.currentLeague).getDocuments { (qs, err) in
            if let err = err
            {
                print("FAILED: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    let users = document.get("userArray") as! [String]
                    let UserSelect = document.get("userSelectArray") as! [String]
                    
                    var svArray : [UIStackView] = []
                    var userArray : [UILabel] = []
                    var userSelectArray : [UILabel] = []
                    
                    var c = 0
                    for i in users
                    {
                        let sv = UIStackView()
                        self.makeStackView(s: sv)
                        svArray.append(sv)
                        self.rankingsStackView.addArrangedSubview(sv)
                        
                        let user = UILabel()
                        self.findUser(l: user, uid: i)
                        user.font = UIFont(name: "AvenirNext-Medium", size: 18)
                        userArray.append(user)
                        //sv.addArrangedSubview(user)
                        
                        let userRank = UILabel()
                        userRank.text = "\(self.findRevenue(str: "\(UserSelect[c])"))"
                        userRank.font = UIFont(name: "AvenirNext-Medium", size: 18)
                        userSelectArray.append(userRank)
                        //sv.addArrangedSubview(userRank)
                        
                        c += 1
                    }
                    
                    var sortedRev : [Int] = []
                    var unSortedRev : [Int] = []
                    for f in userSelectArray
                    {
                        let g = Int(f.text!)!
                        sortedRev.append(g)
                        unSortedRev.append(g)
                    }
                    sortedRev.sort(by: >)
                    
                    var sortedUsers : [UILabel] = []
                    for i in sortedRev
                    {
                        var d = 0
                        for j in unSortedRev
                        {
                            if( i == j )
                            {
                                sortedUsers.append(userArray[d])
                                break
                            }
                            d += 1
                        }
                    }
                    
                    var t = 0
                    for g in userSelectArray
                    {
                        let z = sortedRev[t] as NSNumber
                        let a = NumberFormatter.localizedString(from: z, number: NumberFormatter.Style.decimal)
                        g.text = "$\(a)"
                        t += 1
                    }
                    
                    // CONFLICTING CONSTRAINT???
                    let hec = NSLayoutConstraint(item: self.newView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(800+(sortedUsers.count)))
                    self.newView.addConstraint(hec)
                    var d = 0
                    for j in svArray
                    {
                        j.addArrangedSubview(sortedUsers[d])
                        print(sortedUsers[d].text)
                        j.addArrangedSubview(userSelectArray[d])
                        d += 1
                    }
                }
            }
        }
    }
    
    func makeStackView( s: UIStackView )
    {
        s.axis = .horizontal
        s.alignment = .fill
        s.distribution = .fillEqually
        let heightConstraint = NSLayoutConstraint(item: s, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
        s.addConstraint(heightConstraint)
    }
    
    func findRevenue( str: String ) -> Int
    {
        if( str == "" )
        {
            return 0
        }
        else
        {
            var rev = 0
            for i in str
            {
                let x = "\(i)"
                let y = Int(x)!
                //rev = rev + Constants.movies.weekonebo[y-1]
                rev = rev + revenueArray[y-1]
            }
            return rev
        }
    }
    
    func findUser( l: UILabel, uid: String )
    {
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (qs, err) in
            if let err = err
            {
                print("FAILED: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    l.text = (document.get("firstName") as! String)
                }
            }
        }
    }
}
