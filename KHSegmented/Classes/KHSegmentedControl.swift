//
//  KHSegmentedControl.swift
//  Pods
//
//  Created by Ken M. Hwang on 11/18/18.
//

import UIKit

public protocol KHSegmentedControlDelegate: class {
    func segmentedControlDidDeselect(sc: KHSegmentedControl, view: UIView)
    func segmentedControlDidSelect(sc: KHSegmentedControl, view: UIView)

    func selectAnimation(for view: UIView, in sc: KHSegmentedControl) -> (()->Void)?
    func deselectAnimation(for view: UIView, in sc: KHSegmentedControl) -> (()->Void)?
}

public class KHSegmentedControl: UIControl {
    public var contentInset: UIEdgeInsets {
        get {
            return self.scrollView.contentInset
        }
        
        set {
            self.scrollView.contentInset = newValue
        }
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isDirectionalLockEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let handleView: UIView = {
        let v =  UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var handleViewLeadingConstraint: NSLayoutConstraint!
    private var handleViewWidthConstraint: NSLayoutConstraint!
    
    let bottomIndicator: UIView = {
        let v = UIView()
        v.backgroundColor = v.tintColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var bottomIndicatorHeightConstraint: NSLayoutConstraint!
    
    public var selectedIndex: Int {
        get {
            return self.internalSelectedIndex
        }
        
        set {
            self.setSelectedIndex(newValue, animated: false)
        }
    }
    
    private var internalSelectedIndex = 0 {
        didSet {
            self.contentHasChanged = false
        }
    }
    
    private var contentHasChanged = false
    
    public var segmentedViews:[UIView] {
        get {
            return self.stackView.arrangedSubviews
        }
    }
    
    public weak var delegate: KHSegmentedControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.scrollView.addSubview(self.contentView)
        
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.layoutMarginsGuide.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.layoutMarginsGuide.bottomAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: self.scrollView.layoutMarginsGuide.centerYAnchor).isActive = true

        self.contentView.addSubview(self.stackView)
        self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.contentView.addSubview(self.handleView)
        self.handleView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.handleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.handleViewLeadingConstraint = NSLayoutConstraint(item: self.handleView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        self.contentView.addConstraint(self.handleViewLeadingConstraint)
        self.handleViewWidthConstraint = NSLayoutConstraint(item: self.handleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.contentView.addConstraint(self.handleViewWidthConstraint)
        
        self.handleView.addSubview(self.bottomIndicator)
        self.bottomIndicator.bottomAnchor.constraint(equalTo: self.handleView.bottomAnchor).isActive = true
        self.bottomIndicator.leadingAnchor.constraint(equalTo: self.handleView.leadingAnchor).isActive = true
        self.bottomIndicator.trailingAnchor.constraint(equalTo: self.handleView.trailingAnchor).isActive = true
        self.bottomIndicatorHeightConstraint = NSLayoutConstraint(item: self.bottomIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4)
        self.handleView.addConstraint(self.bottomIndicatorHeightConstraint)
    }    
}

extension KHSegmentedControl {
    @objc func onBtnTapped(_ sender: UIButton) {
        for (i, v) in self.stackView.arrangedSubviews.enumerated() {
            if let b = v as? UIButton, b == sender {
                self.setSelectedIndex(i, animated: true)
                break
            }
        }
    }
}

extension KHSegmentedControl {
    public func append(_ view: UIView) {
        /*
        let mainBlock = {()->Void in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isUserInteractionEnabled = false
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(KHSegmentedControl.onBtnTapped(_:)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(view)
            view.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true

            self.stackView.addArrangedSubview(button)
            self.setNeedsLayout()
        }
        if Thread.isMainThread {
            mainBlock()
        } else {
            DispatchQueue.main.async(execute: mainBlock)
        }
        */
        
        self.insert(view, at: self.stackView.arrangedSubviews.count)
    }
    
    public func insert(_ view: UIView, at index: Int) {
        let mainBlock = {()->Void in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isUserInteractionEnabled = false
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(KHSegmentedControl.onBtnTapped(_:)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(view)
            view.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true

            self.stackView.insertArrangedSubview(button, at: index)
            self.setNeedsLayout()
            
            self.contentHasChanged = true
        }
        if Thread.isMainThread {
            mainBlock()
        } else {
            DispatchQueue.main.async(execute: mainBlock)
        }
    }
    
    public func remove(_ view: UIView) {
        for (i,v) in self.stackView.arrangedSubviews.enumerated() {
            if let b = v as? UIButton, b.subviews.count > 0, b.subviews[0] == view {
                self.remove(at: i)
                break
            }
        }        
    }
    
    public func remove(at index: Int) {
        let mainBlock = {()->Void in
            guard index < self.stackView.arrangedSubviews.count else {
                return
            }

            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
            self.setNeedsLayout()
            
            self.contentHasChanged = true
        }
        if Thread.isMainThread {
            mainBlock()
        } else {
            DispatchQueue.main.async(execute: mainBlock)
        }
    }
    
    public func setSelectedIndex(_ index: Int, animated: Bool) {
        guard index < self.stackView.arrangedSubviews.count else {
            return
        }
        
        let mainBlock = {()->Void in
            self.layoutIfNeeded()
            let oldView = self.stackView.arrangedSubviews[self.selectedIndex]
            self.delegate?.segmentedControlDidDeselect(sc: self, view: oldView.subviews[0])
            
            let oldAnim = self.delegate?.deselectAnimation(for: oldView.subviews[0], in: self)

            let newView = self.stackView.arrangedSubviews[index]
            let newAnim = self.delegate?.selectAnimation(for: newView.subviews[0], in: self)
            let visibleRect = CGRect(x: newView.frame.minX, y: 0, width: newView.frame.width, height: self.scrollView.bounds.height)
            
            var shouldSendActions = false
            if self.internalSelectedIndex != index || self.contentHasChanged {
                shouldSendActions = true
            }
            
            self.internalSelectedIndex = index
            
            if shouldSendActions {
                self.sendActions(for: .valueChanged)
            }
            
            let animations = {()->Void in
                oldAnim?()
                newAnim?()
                self.handleViewLeadingConstraint.constant = newView.frame.minX
                self.handleViewWidthConstraint.constant = newView.frame.width
                self.layoutIfNeeded()
            }
            
            let completion = {(succeed: Bool)->Void in
                self.delegate?.segmentedControlDidSelect(sc: self, view: newView.subviews[0])
            }
            
            if animated {
                UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
            } else {
                animations()
                completion(true)
            }
            
            self.scrollView.scrollRectToVisible(visibleRect, animated: animated)
        }
        if Thread.isMainThread {
            mainBlock()
        } else {
            DispatchQueue.main.async(execute: mainBlock)
        }
    }
}
