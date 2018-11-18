//
//  KHSegmentedScrollViewController.swift
//  Demo
//
//  Created by Ken M. Hwang on 11/18/18.
//  Copyright © 2018 Ken M. Hwang. All rights reserved.
//

import UIKit

open class KHSegmentedScrollViewController: UIViewController {
    public let segmentedControl: KHSegmentedControl = {
        let sc = KHSegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    public var segmentedControlHeight: CGFloat = 60.0 {
        didSet {
            self.segmentedControlHeightConstraint.constant = self.segmentedControlHeight
            self.view.setNeedsLayout()
        }
    }
    
    private var segmentedControlHeightConstraint: NSLayoutConstraint!
    
    let scrollView: UIScrollView = {
        let sv = RemorsefulScrollView(frame: .zero)
        sv.isPagingEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let contentView: UIView = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    private var stackViewWidthConstraint: NSLayoutConstraint!
    
    var selectedIndex: Int {
        get {
            return self.internalSelectedIndex
        }
        
        set {
            self.setSelectedIndex(newValue, animated: false)
        }
    }
    
    private var internalSelectedIndex = 0
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.segmentedControlHeightConstraint = NSLayoutConstraint(item: self.segmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.segmentedControlHeight)
        self.view.addConstraint(self.segmentedControlHeightConstraint)
        self.segmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChaned(_:)), for: .valueChanged)
        
        self.view.addSubview(self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.delegate = self
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor).isActive = true
        
        self.contentView.addSubview(self.stackView)
        self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.stackViewWidthConstraint = NSLayoutConstraint(item: self.stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.contentView.addConstraint(self.stackViewWidthConstraint)
    }
}

extension KHSegmentedScrollViewController {
    public func insert(vc: UIViewController, with segmentedView: UIView, at index: Int) {
        self.segmentedControl.insert(segmentedView, at: index)
        
        let mainBlock = {()->Void in
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            if let sv = vc.view as? UIScrollView {
                sv.contentInsetAdjustmentBehavior = .never
            }
            self.stackView.insertArrangedSubview(vc.view, at: index)
            
            self.stackViewWidthConstraint.constant = self.view.bounds.width * CGFloat(self.stackView.arrangedSubviews.count)
            self.view.setNeedsLayout()
            
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        if Thread.isMainThread {
            mainBlock()
        } else {
            DispatchQueue.main.async(execute: mainBlock)
        }
    }
    
    public func append(vc: UIViewController, with segmentedView: UIView) {
        self.insert(vc: vc, with: segmentedView, at: self.stackView.arrangedSubviews.count)
    }
    
    public func remove(at index: Int) {
        guard index < self.children.count else {
            return
        }

        let v = self.stackView.arrangedSubviews[index]
        
        for vc in self.children {
            if vc.view == v {
                vc.willMove(toParent: nil)
                self.stackView.removeArrangedSubview(v)
                v.removeFromSuperview()
                vc.removeFromParent()
                break
            }
        }
    }
    
    public func remove(vc: UIViewController) {
        guard self.children.contains(vc), self.stackView.arrangedSubviews.contains(vc.view) else {
            return
        }
        
        for (i,v) in self.stackView.arrangedSubviews.enumerated() {
            if v == vc.view {
                self.remove(at: i)
                break
            }
        }
    }
}

extension KHSegmentedScrollViewController {
    @objc func onSegmentedControlValueChaned(_ sender: KHSegmentedControl) {
        let index = sender.selectedIndex
        
        var visibleRect = self.scrollView.bounds
        visibleRect.origin.x = visibleRect.width * CGFloat(index)
        
        self.scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    public func setSelectedIndex(_ index: Int, animated: Bool) {
        self.segmentedControl.setSelectedIndex(index, animated: animated)
    }
}

extension KHSegmentedScrollViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else {
            return
        }
        
        let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.segmentedControl.setSelectedIndex(page, animated: true)
    }
}
