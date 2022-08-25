//
//  PricesViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 5/28/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class PricesViewController: UIViewController
{
    @IBOutlet weak var moviesStackView: UIStackView!
    @IBOutlet weak var movieOne: UIButton!
    
    var fm : [Movie] = []
    var newFM : [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    var theaterarray : [Theater] = []
    
    var name = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var selections = ""
        for i in fm
        {
            selections += i.getImage()
        }
        
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
                    let user = document.get("userArray") as! [String]
                    var userSelect = document.get("userSelectArray") as! [String]
                    var count = 0
                    for i in user
                    {
                        if( i == Auth.auth().currentUser!.uid )
                        {
                            userSelect[count] = selections
                            let x = db.collection("leagues").document(document.documentID)
                            x.updateData(["userSelectArray":userSelect]) { (err) in
                                if err != nil
                                {
                                    print("FAILED")
                                }
                                else
                                {
                                    print("SUCCESS")
                                }
                            }
                        }
                        count += 1
                    }
                }
            }
        }
        //print(selections)
        
        createNewFM()
        addMovies()
    }
    
    func createNewFM()
    {
        for i in fm
        {
            let x = Int( i.getImage() )!
            newFM[x-1] = newFM[x-1] + 1
        }
    }
    
    func addMovies()
    {
        var mov = Movie(i: "", c: 0, m: "")
        var count = 0
        while( count < 8 )
        {
            if( newFM[count] > 0 )
            {
                let stackview = UIStackView()
                makeStackView(s: stackview)
                moviesStackView.addArrangedSubview(stackview)
                
                let x = UIButton()
                for a in fm
                {
                    if( String(count+1) == a.getImage())
                    {
                        mov = a
                        x.setTitle(a.getMovie(), for: .normal)
                        makeButton(b: x)
                        stackview.addArrangedSubview(x)
                        break
                    }
                }
                let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
                makeSlider(s: slider)
                slider.addTarget(self, action: #selector(sliderInAction(_:)), for: UIControl.Event.valueChanged)
                stackview.addArrangedSubview(slider)
                
                let label = UILabel()
                makeLabel(l: label)
                stackview.addArrangedSubview(label)

                let theater = Theater(m: mov, l: label, s: slider)
                theaterarray.append(theater)
                
                //x.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
            }
            count = count + 1
        }
    }
    
    @objc func sliderInAction(_ sender: UISlider)
    {
        //movieOne.setTitle("$\(sender.value)", for: .normal)
        for i in theaterarray
        {
            if( sender == i.getSlider() )
            {
                let x = Int(i.getSlider().value)
                i.getLabel().text = "$\(x)"
            }
        }
    }
    
    func makeStackView( s: UIStackView )
    {
        s.axis = .horizontal
        s.alignment = .fill
//      s.distribution = .fillEqually
//      s.layer.borderWidth = CGFloat(0.25)
        s.spacing = 5
    }
    
    func makeButton( b: UIButton )
    {
        b.setTitleColor(UIColor.black, for: .normal)
        b.contentHorizontalAlignment = .center
        b.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: b, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 175)
        b.addConstraint(widthConstraint)
    }
    
    func makeSlider( s: UISlider )
    {
        s.center = self.view.center
        s.minimumValue = 10
        s.maximumValue = 50
        s.isContinuous = true
        let wc = NSLayoutConstraint(item: s, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 175)
        s.addConstraint(wc)
    }
    
    func makeLabel( l: UILabel )
    {
        l.text = "$10"
        l.textColor = UIColor.black
        let wc = NSLayoutConstraint(item: l, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 34)
        l.addConstraint(wc)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any)
    {
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
                    var count = 0
                    for i in users
                    {
                        if( i == Auth.auth().currentUser!.uid )
                        {
                            break
                        }
                        count+=1
                    }
                    var costArray = document.get("userCostArray") as! [String]
                    var cost = ""
                    for j in self.theaterarray
                    {
                        cost += "\(Int(j.getSlider().value))"
                    }
                    costArray[count] = cost
                    db.collection("leagues").document(document.documentID).updateData(["userCostArray":costArray])
                }
            }
        }
    }
}
