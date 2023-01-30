//
//  AssistiveTouch.swift
//  CiyaShop
//
//  Created by Kaushal PC on 23/10/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

import UIKit

open class AssistiveTouch: UIButton {
    var originPoint = CGPoint.zero
    var screen = UIScreen.main.bounds
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = UIScreen.main.bounds.width
//        let screenHeight = UIScreen.main.bounds.height
//        screen = CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height, width: screenWidth, height: screenHeight - UIApplication.shared.statusBarFrame.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        originPoint = touch.location(in: self)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let nowPoint = touch.location(in: self)
        let offsetX = nowPoint.x - originPoint.x
        let offsetY = nowPoint.y - originPoint.y
//        if offsetY < UIApplication.shared.statusBarFrame.height {
//            offsetY = UIApplication.shared.statusBarFrame.height
//        }

        self.center = CGPoint(x: self.center.x + offsetX, y: self.center.y + offsetY)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }
    
    func reactBounds(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let endPoint = touch.location(in: self)
        let offsetX = endPoint.x - originPoint.x
        let offsetY = endPoint.y - originPoint.y
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        if center.x + offsetX >= screen.width / 2 {
            self.center = CGPoint(x: screen.width - bounds.size.width / 2, y: center.y + offsetY)
        } else {
            self.center = CGPoint(x: bounds.size.width / 2, y: center.y + offsetY)
        }
        if center.y + offsetY >= screen.height - bounds.size.height / 2 {
            self.center = CGPoint(x: center.x, y: screen.height - bounds.size.height / 2)
        } else if center.y + offsetY < bounds.size.height / 2 {
            self.center = CGPoint(x: center.x, y: bounds.size.height / 2)
        }
        UIView.commitAnimations()
    }
    
    override open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
}
