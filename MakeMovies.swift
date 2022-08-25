//
//  MakeMovies.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/4/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MakeMovies
{
    var moviearray : [Movie] = []
    
    var one = 500
    var two = 250
    var three = 100
    var four = 75
    var five = 25
    var six = 20
    var seven = 20
    var eight = 10
    
    var movie1 = "Bad Boys for Life"
    var movie2 = "1917"
    var movie3 = "Sonic the Hedgehog"
    var movie4 = "Jumanji: The Next Level"
    var movie5 = "Star Wars Episode IX"
    var movie6 = "Birds of Prey"
    var movie7 = "Dolittle"
    var movie8 = "Little Women"
    
    init(){}
    
    func movies() -> [Movie]
    {
        moviearray.removeAll()
        
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
                    let x = Movie(i: document.documentID, c: ( document.get("cinecost") as! Int ), m: ( document.get("name") as! String ) )
                    self.moviearray.append(x)
                }
            }
        }
        /*
        moviearray.append(Movie(i: "1", c: one, m: movie1))
        moviearray.append(Movie(i: "2", c: two, m: movie2))
        moviearray.append(Movie(i: "3", c: three, m: movie3))
        moviearray.append(Movie(i: "4", c: four, m: movie4))
        moviearray.append(Movie(i: "5", c: five, m: movie5))
        moviearray.append(Movie(i: "6", c: six, m: movie6))
        moviearray.append(Movie(i: "7", c: seven, m: movie7))
        moviearray.append(Movie(i: "8", c: eight, m: movie8))
        */
        return moviearray
    }
    
    func moviesWithInfo() -> [Movie]
    {
        moviearray.removeAll()
        
        moviearray.append(Movie(i: "1", c: one, m: movie1, inter: 99, b: 23.3, t: 419.1, r: 77, im: 6.7))
        moviearray.append(Movie(i: "2", c: two, m: movie2, inter: 99, b: 36.5, t: 159.2, r: 89, im: 8.3))
        moviearray.append(Movie(i: "3", c: three, m: movie3, inter: 99, b: 57, t: 306.8, r: 64, im: 6.6))
        moviearray.append(Movie(i: "4", c: four, m: movie4, inter: 99, b: 60.1, t: 300, r: 71, im: 6.7))
        moviearray.append(Movie(i: "5", c: five, m: movie5, inter: 99, b: 117.4, t: 1000, r: 52, im: 6.7))
        moviearray.append(Movie(i: "6", c: six, m: movie6, inter: 99, b: 81.25, t: 201.9, r: 78, im: 6.1))
        moviearray.append(Movie(i: "7", c: seven, m: movie7, inter: 99, b: 50, t: 223.3, r: 14, im: 5.6))
        moviearray.append(Movie(i: "8", c: eight, m: movie8, inter: 99, b: 35.3, t: 206, r: 95, im: 7.9))
        
        return moviearray
    }
}
