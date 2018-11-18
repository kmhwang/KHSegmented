//
//  ViewController.swift
//  Demo
//
//  Created by Ken M. Hwang on 11/15/18.
//  Copyright © 2018 Ken M. Hwang. All rights reserved.
//

import UIKit
import KHSegmented

class ViewController: KHSegmentedScrollViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sb = self.storyboard!
        
        for i in 0..<10 {
            let label = UILabel(frame: CGRect.zero)
            if i % 2 == 0 {
                label.text = "Hello \(i)"
            } else {
                label.text = "World \(i)"
            }
            
            let vc = sb.instantiateViewController(withIdentifier: "TestTableViewController")
            
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1)
            
            self.append(vc: vc, with: label)
        }
        
        self.segmentedControl.delegate = self
        
        self.segmentedControl.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController: KHSegmentedControlDelegate {
    func segmentedControlDidSelect(sc: KHSegmentedControl, view: UIView) {
        /*
        if let l = view as? UILabel {
            l.textColor = self.view.tintColor
        }
        */
    }
    
    func segmentedControlDidDeselect(sc: KHSegmentedControl, view: UIView) {
        /*
        if let l = view as? UILabel {
            l.textColor = UIColor.black
        }
        */
    }
    
    func selectAnimation(for view: UIView, in sc: KHSegmentedControl) -> (() -> Void)? {
        if let l = view as? UILabel {
            return {()->Void in
                l.textColor = self.view.tintColor
            }
        }
        
        return nil
    }
    
    func deselectAnimation(for view: UIView, in sc: KHSegmentedControl) -> (() -> Void)? {
        if let l = view as? UILabel {
            return {()->Void in
                l.textColor = UIColor.black
            }
        }
        
        return nil
    }
}

