//
//  UIView+Layer.swift
//  MeicunFarm
//
//  Created by jutubao on 2019/5/7.
//  Copyright © 2019年 MC. All rights reserved.
//

import UIKit
extension UIView {
    //  圆角
    @IBInspectable var swCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }
    //  边线宽度
    @IBInspectable var swBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    //  边线颜色
    @IBInspectable var swBorderColor: UIColor {
        get {
            return layer.swBorderUIColor
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
}
//  设置边线颜色
extension CALayer {
    var swBorderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}

// MARK: - 坐标计算
extension UIView {
    var mc_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            let frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            let frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            let frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            let frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
            self.frame = frame
        }
    }
    
    var mc_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            let frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            let frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            let frame = CGRect(x: newValue - self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            let frame = CGRect(x: self.frame.origin.x, y: newValue - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
            self.frame = frame
        }
    }
    
    var mc_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            let point = CGPoint(x: newValue, y: self.center.y)
            self.center = point
        }
    }
    
    var mc_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            let point = CGPoint(x: self.center.x, y: newValue)
            self.center = point
        }
    }
}

// MARK: - 部分圆角
extension UIView {
    
    /// 设置部分圆角(绝对布局)
    ///
    /// - Parameters:
    ///   - corners: 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
    ///   - raddii: 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
    func addRoundedConners(withCorners corners: UIRectCorner, raddii: CGSize, hex: String) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: raddii)
//        let shap = CAShapeLayer()
//        shap.path = rounded.cgPath
        
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = rounded.cgPath
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(borderLayer)
        
//        self.layer.mask = shap
    }
    
    func setCornersRadius(radius: CGFloat, roundingCorners: UIRectCorner) {
        
//        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskPath.cgPath
//        maskLayer.shouldRasterize = true
//        maskLayer.rasterizationScale = UIScreen.main.scale
//
//        self.layer.mask = maskLayer
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds,

            byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topRight],

            cornerRadii: CGSize(width: radius, height: radius))

            let maskLayer = CAShapeLayer()

            maskLayer.frame = self.bounds

            maskLayer.path = maskPath.cgPath

            self.layer.mask = maskLayer


    }

}

// MARK: - 生成图片
extension UIView {
    
    /// view生成图片
    func saveViewImage() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

