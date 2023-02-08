//
//  UIViewExtensions.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/20.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

public extension UIView {
    
    fileprivate struct AssociatedKeys {
        static var graidentLayerName = "cmc_graident_layer"
    }
    
    public func cmc_addGradientLayer(colors:[CGColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? = [0.0, 0.5, 1.0]) {
        
        if let tmpSubLayer = self.layer.sublayers {
            for itemLayer in tmpSubLayer {
                if itemLayer.name == AssociatedKeys.graidentLayerName {
                    itemLayer.removeFromSuperlayer()
                    break
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.name = AssociatedKeys.graidentLayerName
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    /// 设置GradientLayer alpha 在调用些方法之前需调用 cmc_addGradientLayer 方法
    ///
    /// - Parameter alpha: 透明度
    public func cmc_setGradientLayer(alpha: Float) {
        
        if let tmpSubLayer = self.layer.sublayers {
            for itemLayer in tmpSubLayer {
                if itemLayer.name == AssociatedKeys.graidentLayerName {
                    itemLayer.opacity = alpha
                    break
                }
            }
        }
    }
    
    public func cmc_drawLineStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.h), cornerRadius: self.h/2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
}
