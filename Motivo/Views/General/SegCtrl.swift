//
//  SegCtrl.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/1/25.
//

import UIKit

let segCtrlHeight:CGFloat = 50

class SegCtrl: UISegmentedControl {

    // color properties
    var normalTextColor: UIColor = colorMainText {
        didSet {
            updateSegmentColors()
        }
    }
    var selectedTextColor: UIColor = .systemBackground {
        didSet {
            updateSegmentColors()
        }
    }
    var segmentBackgroundColor: UIColor = .systemBackground {
        didSet {
            updateSegmentBackgroundColor()
        }
    }
    var selectedSegmentBackgroundColor: UIColor = colorMainPrimary {
        didSet {
            updateSelectedSegmentBackgroundColor()
        }
    }
    
    // Init
    override init(items: [Any]?) {
        super.init(items: items)
        setupSegCtrlUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegCtrlUI() {
        self.selectedSegmentTintColor = selectedSegmentBackgroundColor
        updateSegmentColors()
        updateSegmentBackgroundColor()
    }
    
    private func updateSegmentColors() {
        // Set the text color for normal and selected states
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: normalTextColor,
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTextColor,
        ]
        
        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    private func updateSegmentBackgroundColor() {
        self.backgroundColor = segmentBackgroundColor
    }
    
    private func updateSelectedSegmentBackgroundColor() {
        self.selectedSegmentTintColor = selectedSegmentBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
//        let selectedIndex = self.selectedSegmentIndex
//        guard selectedIndex != UISegmentedControl.noSegment else { return nil }
//        self.subViews[selectedIndex] = self.bounds.height / 2
//        for segment in subviews {
//            segment.layer.cornerRadius = self.bounds.height / 2
//            segment.layer.masksToBounds = true
//        }
        
//        for (index, segment) in subviews.enumerated() {
//            if selectedSegmentIndex == index {
//                segment.layer.cornerRadius = self.bounds.height / 2
//                segment.layer.masksToBounds = true
//            }
//        }
        
//        for (index, segment) in subviews.enumerated() {
//            if index == selectedSegmentIndex {
//                segment.layer.cornerRadius = self.bounds.height / 2 // Round the selected segment
//            } else {
//                segment.layer.cornerRadius = 0 // Keep unselected segments sharp
//            }
//            segment.layer.masksToBounds = true
//        }
    }
}
