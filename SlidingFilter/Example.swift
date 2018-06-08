//
//  ViewController.swift
//  SlidingFilter
//
//  Created by Peter Tao on 6/4/18.
//  Copyright © 2018 Peter Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blue = UIView()
        blue.backgroundColor = UIColor.blue
        
        let red = UIView()
        red.backgroundColor = UIColor.red
        
        let green = UIView()
        green.backgroundColor = UIColor.green
        
        let purple = UIView()
        purple.backgroundColor = UIColor.purple
        
        
        let x = SegmentedScrollView(frame: CGRect(x:0, y:60, width:self.view.frame.width, height: self.view.frame.height), segmentViews: [(blue,"Blue"), (red, "Red"), (green,"Green"), (purple,"Purple")])
        
        self.view.addSubview(x)

    }
    
    

}
