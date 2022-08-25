//
//  File.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 5/25/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation
import UIKit

class Movie
{
    var image : String  // title of the image movie ( 1-8 )
    var cost : Int      // cost of the movie
    var movie = ""      // name of the movie
    var interest = 0
    var bo1 = 0.0        // box office week 1
    var tbo = 0.0        // total box office
    var rt = 0          // rotten tomatoes
    var imdb = 0.0        // imdb score
    
    init( i : String, c : Int )
    {
        image = i
        cost = c
    }
    
    init( i : String, c : Int, m : String )
    {
        image = i
        cost = c
        movie = m
    }
    
    init( i : String, c : Int, m : String, inter : Int, b : Double, t : Double, r : Int, im : Double )
    {
        image = i
        cost = c
        movie = m
        interest = inter
        bo1 = b
        tbo = t
        rt = r
        imdb = im
    }
    
    // set functions
    
    func setImage( i : String )
    {
        image = i
    }
    
    func setCost( c : Int )
    {
        cost = c
    }
    
    func setMovie( m : String )
    {
        movie = m
    }
    
    func setInterest( inter : Int )
    {
        interest = inter
    }
    
    func setBoxOfficeWeek1( b : Double )
    {
        bo1 = b
    }
    
    func setTotalBoxOffice( t : Double )
    {
        tbo = t
    }
    
    func setRTScore( r : Int )
    {
        rt = r
    }
    
    func setIMDB( im: Double )
    {
        imdb = im
    }
    
    // get functions
    
    func getImage() -> String
    {
        return image
    }
    
    func getCost() -> Int
    {
        return cost
    }
    
    func getMovie() -> String
    {
        return movie
    }
    
    func getBoxOfficeWeek1() -> Double
    {
        return bo1
    }
    
    func getTotalBoxOffice() -> Double
    {
        return tbo
    }
    
    func getRTScore() -> Int
    {
        return rt
    }
    
    func getIMDB() -> Double
    {
        return imdb
    }
    
    func getInterest() -> Int
    {
        return interest
    }
}
