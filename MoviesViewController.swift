//
//  MoviesViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 5/24/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class MoviesViewController: UIViewController
{
    var finalMovies : [Movie] = []
    //array of theaters
    var theaterarray : [UIButton] = []
    //array of movies and cost
    var moviearray : [Movie] = []
    
    @IBOutlet weak var money: UILabel!
    var count = 1000
    
    //movies cost
    @IBOutlet weak var cost1: UILabel!
    @IBOutlet weak var cost2: UILabel!
    @IBOutlet weak var cost3: UILabel!
    @IBOutlet weak var cost4: UILabel!
    @IBOutlet weak var cost5: UILabel!
    @IBOutlet weak var cost6: UILabel!
    @IBOutlet weak var cost7: UILabel!
    @IBOutlet weak var cost8: UILabel!
    

    
    //movies
    @IBOutlet weak var movie1: UIButton!
    @IBOutlet weak var movie2: UIButton!
    @IBOutlet weak var movie3: UIButton!
    @IBOutlet weak var movie4: UIButton!
    @IBOutlet weak var movie5: UIButton!
    @IBOutlet weak var movie6: UIButton!
    @IBOutlet weak var movie7: UIButton!
    @IBOutlet weak var movie8: UIButton!
    
    //theaters
    @IBOutlet weak var theater1: UIButton!
    @IBOutlet weak var theater2: UIButton!
    @IBOutlet weak var theater3: UIButton!
    @IBOutlet weak var theater4: UIButton!
    @IBOutlet weak var theater5: UIButton!
    @IBOutlet weak var theater6: UIButton!
    @IBOutlet weak var theater7: UIButton!
    @IBOutlet weak var theater8: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        theaterarray = [theater1, theater2, theater3, theater4, theater5, theater6, theater7, theater8]
        
    
        //let x = MakeMovies.init()
        //moviearray = x.movies()
        let costarray = [cost1, cost2, cost3, cost4, cost5, cost6, cost7, cost8]
        let picarray = [movie1, movie2, movie3, movie4, movie5, movie6, movie7, movie8]
        var c = 0
        
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
                    let cost = document.get("cinecost") as! Int
                    costarray[c]!.text = "$\(cost)"
                    //costarray[c]!.font = UIFont(name: "Avenir Next Medium", size: 17)
                    
                    picarray[c]?.setImage(UIImage(named: document.documentID), for: .normal)
                    
                    let x = Movie(i: document.documentID, c: ( document.get("cinecost") as! Int ), m: ( document.get("name") as! String ) )
                    self.moviearray.append(x)
                    c += 1
                }
            }
        }
    }
    
    @IBAction func movie1Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[0])
    }
    @IBAction func movie2Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[1])
    }
    @IBAction func movie3Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[2])
    }
    @IBAction func movie4Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[3])
    }
    @IBAction func movie5Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[4])
    }
    @IBAction func movie6Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[5])
    }
    @IBAction func movie7Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[6])
    }
    @IBAction func movie8Pressed(_ sender: Any)
    {
        putMovieInTheater(movie: moviearray[7])
    }
    
    //adds movie to theater and subtracts cost of movie
    func putMovieInTheater( movie : Movie )
    {
        if( count - movie.getCost() >= 0 && allTheatersFilled() == false )
        {
            for i in theaterarray
            {
                if( isTheaterFilled(button: i) == false )
                {
                    finalMovies.append(movie)
                    i.setImage(UIImage(named: movie.getImage()), for: .normal)
                    break
                }
            }
            
            count = count - movie.getCost()
            money.text = "$\(count)"
        }
    }
    
    @IBAction func theater1Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater1)
    }
    @IBAction func theater2Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater2)
    }
    @IBAction func theater3Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater3)
    }
    @IBAction func theater4Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater4)
    }
    @IBAction func theater5Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater5)
    }
    @IBAction func theater6Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater6)
    }
    @IBAction func theater7Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater7)
    }
    @IBAction func theater8Pressed(_ sender: Any)
    {
        removeMovieInTheater(button: theater8)
    }
    
    //removes movie from theater and adds cost of movie
    func removeMovieInTheater( button : UIButton )
    {
        if( button.currentImage != nil )
        {
            for i in moviearray
            {
                if( button.currentImage == UIImage(named: i.getImage()) )
                {
                    var c = 0
                    for j in finalMovies
                    {
                        if( button.currentImage == UIImage(named: j.getImage()) )
                        {
                            finalMovies.remove(at: c)
                            break
                        }
                        c = c + 1
                    }
                    
                    count = count + i.getCost()
                    money.text = "$\(count)"
                    break
                }
            }
            button.setImage(nil, for: UIControl.State.normal)
        }
    }
    
    //checks if certain theater is filled
    func isTheaterFilled( button: UIButton ) -> Bool
    {
        if( button.currentImage != nil )
        {
            return true
        }
        return false
    }
    
    //checks if all the theaters are filled
    func allTheatersFilled() -> Bool
    {
        var filled = true
        for i in theaterarray
        {
            if( i.currentImage == nil )
            {
                filled = false
            }
        }
        return filled
    }
    
    @IBAction func goToPrices(_ sender: Any)
    {
        performSegue(withIdentifier: "pricesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! PricesViewController
        vc.fm = finalMovies
        vc.name = "Hello"
    }
}
