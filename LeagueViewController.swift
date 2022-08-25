//
//  League.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 4/19/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation

class League
{
    var username = ""
    var password = ""
    
    init(){}
    
    init( user: String, pass: String )
    {
        self.username = user
        self.password = pass
    }
    
    init( user: String )
    {
        username = user
    }
    
    // set functions
    func setusername( user: String )
    {
        self.username = user
    }
    
    func setpassword( pass: String )
    {
        self.password = pass
    }
    
    //get functions
    func getusername() -> String
    {
        return username
    }
    
    func getpassword() -> String
    {
        return password
    }
}
