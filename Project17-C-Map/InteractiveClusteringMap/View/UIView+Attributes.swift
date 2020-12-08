//
//  Round+ShadowView.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/09.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return UIColor.init(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOffset : CGSize{
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get{ return UIColor.init(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue.cgColor }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get{ return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue}
    }
}
