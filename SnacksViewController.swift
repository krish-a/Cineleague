//
//  SnacksViewController.swift
//  Cineleague
//
//  Created by Krishanraj Ashok on 6/1/20.
//  Copyright © 2020 Krishanraj Ashok. All rights reserved.
//

import UIKit

class SnacksViewController: UIViewController
{
    @IBOutlet weak var popcornSlider: UISlider!
    @IBOutlet weak var drinkSlider: UISlider!
    
    @IBOutlet weak var popcornPrice: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func popcornSliderMoved(_ sender: Any)
    {
        let x = Int(popcornSlider.value)
        popcornPrice.text = "$\(x)"
    }
    
    @IBAction func drinkSliderMoved(_ sender: Any)
    {
        let x = Int(drinkSlider.value)
        drinkPrice.text = "$\(x)"
    }
}
