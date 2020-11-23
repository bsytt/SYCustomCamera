//
//  UIViewExtension.swift
//  Nongjibang
//
//  Created by xiyang on 2017/8/28.
//  Copyright © 2017年 gaofan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public struct UIRectSide : OptionSet {
    
    public let rawValue: Int
    public static let left = UIRectSide(rawValue: 1 << 0)
    public static let top = UIRectSide(rawValue: 1 << 1)
    public static let right = UIRectSide(rawValue: 1 << 2)
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    public static let all: UIRectSide = [.top, .right, .left, .bottom]
    public init(rawValue: Int) {
        self.rawValue = rawValue;
    }
    
}

extension UIView{
    
    func viewController() -> UIViewController? {
        
        var next = self.superview
        while (next != nil) {
            let responder = next?.next
            if responder is UIViewController{
                return responder as? UIViewController
            }
            next = next?.superview
        }
        
        return nil
        
    }
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat , frames:CGRect) {
        let maskPath = UIBezierPath(roundedRect: frames, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = frames
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //打电话
    func phoneCall(phoneStr:String){
        let phoneNum    = "tel:\(phoneStr)"
        let callWedView = WKWebView()
        let request     = URLRequest(url: URL(string:phoneNum)!)
        callWedView.load(request)
        self.addSubview(callWedView)
    }
    
    ///画虚线边框
    
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: UIRectSide) {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        shapeLayer.strokeColor = strokeColor.cgColor
        
        
        
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        
        
        let path = CGMutablePath()
        
        if corners.contains(.left) {
            
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
        
        if corners.contains(.top){
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
        }
        
        if corners.contains(.right){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
        }
        
        if corners.contains(.bottom){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    
    /// 根据view尺寸截图
    /// - Parameter rect: 尺寸大小
    func takeSnapshot(in snapRect:CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(snapRect.size, self.isOpaque, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

