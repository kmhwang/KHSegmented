//
//  KHSegmented_ExampleTests.swift
//  KHSegmented_ExampleTests
//
//  Created by Ken M. Hwang on 11/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import KHSegmented

class KHSegmented_ExampleTests: XCTestCase {
    let khVC = KHSegmentedScrollViewController()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        for i in 0..<10 {
            let label = UILabel(frame: CGRect.zero)
            if i % 2 == 0 {
                label.text = "Hello \(i)"
            } else {
                label.text = "World \(i)"
            }
            
            let vc = UIViewController()
            
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1)
            
            self.khVC.append(vc: vc, with: label)
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppend() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let label = UILabel(frame: .zero)
        label.text = "Test"
        
        let vc = UIViewController()
        
        vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1)
        
        self.khVC.append(vc: vc, with: label)
        
        XCTAssertTrue(self.khVC.children.count == 11, "Child view controllers should equal to 11")
    }
}
