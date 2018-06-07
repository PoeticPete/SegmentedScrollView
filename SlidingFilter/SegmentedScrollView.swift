//
//  SegmentedScrollView.swift
//  SlidingFilter
//
//  Created by Peter Tao on 6/7/18.
//  Copyright © 2018 Peter Tao. All rights reserved.
//

import UIKit

/// A scroll view that has added segments above it that allow a user to tap on a view to see.
class SegmentedScrollView: UIView, UIScrollViewDelegate, SlidingFilterDelegate {
    
    
    // MARK: - Variables
    /// The array of views this SegmentedScrollView contains each view must be the width of the screen.
    var views:[UIView] = []
    
    /// The sliding filter view that displays the filters.
    var slidingFilter: SlidingFilter!
    
    /// The titles of each filter. Displayed on each filter button.
    var segmentTitles:[String] = []
    
    /// The height of the sliding filter. Default 40 pixels.
    static var slidingFilterHeight:CGFloat = 40
    
    /// The scrollview used to display the multiple views.
    var scrollView: UIScrollView!
    
    /// The SegmentedScrollView manages the selected filter when the user drags the scroll view.
    /// The Sliding Filter manages the selected filter when the user taps on a filter button.
    private var shouldManageSelection = true
    
    // MARK: - Initializer
    /**
     Initializes the SegmentedScrollView.
     
     - Parameter frame: The frame of the view.
     - Parameter segmentTitles: The titles of the segments.
     - Parameter views: The views to be added to the scroll view. Each view will fall under a segment title.
     
     */
    init(frame: CGRect, segmentTitles: [String], views:[UIView]) {
        super.init(frame: frame)
        slidingFilter = SlidingFilter(frame: CGRect(x: 0, y: 0, width: frame.width, height: SegmentedScrollView.slidingFilterHeight))
        slidingFilter.delegate = self
        
        self.addSubview(slidingFilter)
        
        self.segmentTitles = segmentTitles
        self.views = views
        
        scrollView = UIScrollView(frame: SegmentedScrollView.getSubviewFrame())
        self.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: SegmentedScrollView.getSubviewFrame().width * CGFloat(views.count), height: SegmentedScrollView.getSubviewFrame().height)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        for i in 0..<views.count {
            let firstFrame = SegmentedScrollView.getSubviewFrame()
            
            // adjust to ith frame
            views[i].frame = CGRect(x: firstFrame.width * CGFloat(i), y: 0, width: firstFrame.width, height: firstFrame.height)
            scrollView.addSubview(views[i])
        }
        
        slidingFilter.segments = segmentTitles
    }
    
    
    // MARK: - UIScrollViewDelegate
    /**
     As the scroll view is moved, this method will update the bottom bar of the sliding filter.
     It will also update the currently selected segment as the user scrolls.
     
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if shouldManageSelection {
            let currSelectedIndex = self.slidingFilter.selected
            let viewWidth = SegmentedScrollView.getSubviewFrame().width
            
            let lower = CGFloat(currSelectedIndex) * viewWidth - 0.5 * viewWidth
            let upper = CGFloat(currSelectedIndex) * viewWidth + 0.5 * viewWidth
            
            if scrollView.contentOffset.x > upper {
                slidingFilter.setSelection(tag: currSelectedIndex + 1)
            }
            
            if scrollView.contentOffset.x < lower {
                slidingFilter.setSelection(tag: currSelectedIndex - 1)
            }
        }
        
        
        // update the bottom line
        slidingFilter.bottomLine.frame = CGRect(x: scrollView.contentOffset.x/CGFloat(views.count), y:slidingFilter.bottomLine.frame.minY, width: slidingFilter.bottomLine.frame.width, height: slidingFilter.bottomLine.frame.height)
        
    }
    
    /**
     Sets shouldManageSelection to true when the scroll view is done animating.
     The scroll view will animate to change views when the user taps on a segment.
     
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        shouldManageSelection = true
    }
    
    
    
    // MARK: - SlidingFilterDelegate
    /**
     Called when the user taps on a segment. Sets shouldManageSelection to false so the scroll view will not update
     the selected index (as it is always updated in the slidingFilter method)
     
     - Parameter index: the index of the segment tapped
     */
    func segmentTapped(index: Int) {
        shouldManageSelection = false
        slidingFilter.setSelection(tag: index)
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * SegmentedScrollView.getSubviewFrame().width, y: 0), animated: true)
    }
    
    /**
     Gets the current index
     
     - Returns: index of the selected index
     */
    func getSelectedIndex() -> Int {
        return slidingFilter.selected
    }
    
    // MARK: - Static functions
    
    /**
     Gets the frame of a child view. When adding a view to the SegmentedScrollView,
     this function should be called to get the appropriate size for the child.
     */
    static func getSubviewFrame() -> CGRect {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let slidingFilterHeight = self.slidingFilterHeight
        
        return CGRect(x: 0, y: statusBarHeight + slidingFilterHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (statusBarHeight + slidingFilterHeight))
    }
    
    
    // MARK: - Miscellaneous
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

/// An array of buttons with a line under the selected button
class SlidingFilter: UIView {
    
    /// array of segments (ie. viewOneTitle, viewTwoTitle, etc.)
    var segments:[String] = [] {
        didSet {
            createSegments()
        }
    }
    
    /// the current filter selected
    var selected = 0
    
    /// the bottom line that moves with the scroll view (only for aesthetic purposes)
    var bottomLine: UIView!
    
    /// the width of one button, dynamically adjusted based on nubmer of buttons
    var buttonWidth:CGFloat!
    
    /// The color of the filter button when selected (default is black). Also the color of the bottom line.
    let selectedColor = UIColor.black
    
    /// The color of the filter button when unselected (default is gray)
    let unselectedColor = UIColor.gray
    
    /// The array of filter buttons
    private var buttons:[UIButton] = []
    
    /// The delegate used to notify the parent of a button tap
    var delegate: SlidingFilterDelegate?
    
    /**
     Creates the segments based on the provided strings in the segments array.
     */
    func createSegments() {
        self.layoutIfNeeded()
        buttonWidth = self.frame.width / CGFloat(self.segments.count)   // width of one button
        // create buttons
        for i in 0..<self.segments.count {
            let button = UIButton()
            self.addSubview(button)
            button.setTitle(segments[i], for: .normal)
            
            button.frame = CGRect(x: CGFloat(i)*buttonWidth, y: 0, width: buttonWidth, height: self.frame.height)
            button.addTarget(self, action: #selector(segmentTapped), for: .touchUpInside)
            button.tag = i
            button.setTitleColor(selectedColor, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            buttons.append(button)
        }
        
        // add the bottom line
        bottomLine = UIView()
        self.addSubview(bottomLine)
        self.setSelection(tag: 0)
        bottomLine.frame = CGRect(x: 0, y: self.frame.height-1, width: buttonWidth, height: 1)
        bottomLine.backgroundColor = selectedColor
    }
    
    /**
     Called when a segment is tapped
     
     - Parameter sender: The UIButton that was tapped
     */
    @objc func segmentTapped(sender: UIButton) {
        setSelection(tag: sender.tag)
        delegate?.segmentTapped(index: sender.tag)
    }
    
    /**
     Sets a segment to be selected.
     
     - Parameter tag: The tag of the button/segment to be selected. Each button's tag is set when createSegments is called.
     */
    func setSelection(tag: Int) {
        selected = tag
        for b in self.buttons {
            b.setTitleColor(self.unselectedColor, for: .normal)
        }
        self.buttons[tag].setTitleColor(self.selectedColor, for: .normal)
    }
    
    
}

/// The delegate object used to connect the SegmentedScrollView with the SlidingFilter.
protocol SlidingFilterDelegate {
    func segmentTapped(index: Int)
}
