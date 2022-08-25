//
//  Theater.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 5/31/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import Foundation
import UIKit

class Theater
{
    var movie : Movie
    var label : UILabel
    var slider : UISlider
    
    init( m : Movie, l : UILabel, s : UISlider )
    {
        movie = m
        label = l
        slider = s
    }

    func getMovie() -> Movie
    {
        return movie
    }
    
    func getLabel() -> UILabel
    {
        return label
    }

    func getSlider() -> UISlider
    {
        return slider
    }
    
    func setMovie( m : Movie )
    {
        movie = m
    }
    
    func setLabel( l : UILabel )
    {
        label = l
    }
    
    func setSlider( s : UISlider )
    {
        slider = s
    }
}
