//
//  Constants.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/7/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

struct Constants
{
    struct storyboard
    {
        static let homeviewcontroller = "NavViewController"//"HomeViewController"
        static var currentLeague = ""
        static var currentLeagueSelections = ""
        static var uid = Auth.auth().currentUser?.uid
    }
    
    struct movies
    {
        static let one = 23300000
        static let two = 36500000
        static let three = 57000000
        static let four = 60100000
        static let five = 174000000
        static let six = 81250000
        static let seven = 50000000
        static let eight = 35300000
        static let weekonebo = [23300000, 36500000, 57000000, 60100000, 174000000, 81250000, 50000000, 35300000]
    }
}
