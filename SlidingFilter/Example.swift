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
        
        let blue = UIView(frame: SegmentedScrollView.getSubviewFrame())
        blue.backgroundColor = UIColor.blue
        
        let red = UIView(frame: SegmentedScrollView.getSubviewFrame())
        red.backgroundColor = UIColor.red
        
        let green = UIView(frame: SegmentedScrollView.getSubviewFrame())
        green.backgroundColor = UIColor.green
        
        let purple = UIView(frame: SegmentedScrollView.getSubviewFrame())
        purple.backgroundColor = UIColor.purple
        
        
        let x = SegmentedScrollView(frame: CGRect(x:0, y:20, width:self.view.frame.width, height: self.view.frame.height), segmentTitles: ["Blue", "Red", "Green", "Purple"], views: [blue, red, green, purple])
        
        self.view.addSubview(x)

    }
    
    

}
