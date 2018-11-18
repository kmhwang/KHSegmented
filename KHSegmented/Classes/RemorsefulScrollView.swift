//
//  RemorsefulScrollView.swift
//  Demo
//
//  Created by Ken M. Hwang on 11/18/18.
//  Copyright © 2018 Ken M. Hwang. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/728014/uiscrollview-paging-horizontally-scrolling-vertically
class RemorsefulScrollView: UIScrollView {
    var originalPoint = CGPoint()
    var isHorizontalScroll = false
    var isMultitouch = false
    var currentChild: UIView? = nil
    
    // the numbers from an example in Apple docs, may need to tune them
    static let kThresholdX: CGFloat = 12
    static let kThresholdY: CGFloat = 4
    
    func honestHitTest(_ point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var result: UIView? = nil
        
        for child in self.subviews {
            if child.point(inside: point, with: event) {
                result = child.hitTest(point, with: event)
                
                if result != nil {
                    break
                }
            }
        }
        
        return result
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delaysContentTouches = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delaysContentTouches = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // always forward touchesBegan -- there's no way to forward it later
        super.touchesBegan(touches, with: event)
        
        guard let e = event else {
            return
        }
        
        let numOfEventTouches = e.touches(for: self)?.count ?? 0
        
        if self.isHorizontalScroll { // UIScrollView is in charge now
            return
        }
        
        if touches.count == numOfEventTouches { // initial touch
            if let anyTouch = touches.first {
                self.originalPoint = anyTouch.location(in: self)
                self.currentChild = self.honestHitTest(self.originalPoint, withEvent: event)
                self.isMultitouch = false
            }
        }
        
        self.isMultitouch = self.isMultitouch || (numOfEventTouches > 1)
        
        self.currentChild?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isHorizontalScroll && !self.isMultitouch {
            if let anyTouch = touches.first {
                let point = anyTouch.location(in: self)
                
                if (abs(self.originalPoint.x - point.x) > RemorsefulScrollView.kThresholdX)
                    && (abs(self.originalPoint.y - point.y) < RemorsefulScrollView.kThresholdY) {
                    self.isHorizontalScroll = true
                    self.currentChild?.touchesCancelled(event!.touches(for: self)!, with: event)
                }
            }
        }
        
        if self.isHorizontalScroll {
            super.touchesMoved(touches, with: event)
        } else {
            self.currentChild?.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isHorizontalScroll {
            super.touchesEnded(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
            self.currentChild?.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if self.isHorizontalScroll {
            self.currentChild?.touchesCancelled(touches, with: event)
        }
    }

}
