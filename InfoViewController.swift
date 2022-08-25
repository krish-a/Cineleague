//
//  InfoViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 5/25/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class InfoViewController: UIViewController
{
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var movie1: UIButton!
    @IBOutlet weak var movie2: UIButton!
    @IBOutlet weak var movie3: UIButton!
    @IBOutlet weak var movie4: UIButton!
    @IBOutlet weak var movie5: UIButton!
    @IBOutlet weak var movie6: UIButton!
    @IBOutlet weak var movie7: UIButton!
    @IBOutlet weak var movie8: UIButton!
    
    var nametext = ""
    var imagetext = "8"
    var interest = 0
    var bow1 = 0.0
    var tbo = 0.0
    var cprice = 0
    var rt = 0
    var imdb = 0.0
    
    var moviearray : [Movie] = []
    var movies : [UIButton] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        background.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 200/255, green: 0, blue: 0, alpha: 1))
        //background.backgroundColor = UIColor.white
        
        let x = MakeMovies.init()
        moviearray = x.moviesWithInfo()
        
        setMovieNames()
        
        let banners = [1, 2, 3, 4, 5, 6, 7, 8]
        let movies = [movie1, movie2, movie3, movie4, movie5, movie6, movie7, movie8]
        var count = 0
        for i in movies
        {
            i?.setImage(UIImage(named: "\(banners[count])banner"), for: .normal) 
            count += 1
            
            i?.layer.borderWidth = CGFloat(1)
            i?.layer.borderColor = UIColor.white.cgColor
            //i?.layer.borderColor = CGColor(srgbRed: 200/255, green: 0, blue: 0, alpha: 1)
            i?.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setMovieNames()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setMovieNames()
    {
        let movies = [movie1, movie2, movie3, movie4, movie5, movie6, movie7, movie8]
        var count = 0
        
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
                    let name = document.get("name") as! String
                    movies[count]?.setTitle(name, for: .normal)
                    count += 1
                }
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        let db = Firestore.firestore()
        db.collection("movies").whereField("name", isEqualTo: sender.titleLabel!.text!).getDocuments { (qs, err) in
            if let err = err
            {
                print("ERROR: \(err)")
            }
            else
            {
                for document in qs!.documents
                {
                    self.imagetext = document.documentID
                    self.nametext = ( document.get("name") as! String )
                    self.interest = ( document.get("interest") as! Int )
                    self.bow1 = ( document.get("bo") as! Double )
                    self.cprice = ( document.get("cinecost") as! Int )
                    self.rt = ( document.get("rt") as! Int )
                    self.imdb = ( document.get("imdb") as! Double )
                    
                    self.performSegue(withIdentifier: "MovieInfoSegue", sender: self)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! MovieInfoViewController
        vc.finalname = nametext
        vc.finalposter = imagetext
        vc.finalinterest = interest
        vc.finalbow1 = bow1
        vc.finaltbo = tbo
        vc.finalcprice = cprice
        vc.finalrt = rt
        vc.finalimdb = imdb
    }
}
