//
//  ViewController+Toast.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/19.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                               y: self.view.frame.size.height-100,
                                               width: 150, height: 40))
        
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds  =  true
        toastLabel.sizeToFit()
        toastLabel.frame.origin = CGPoint(x: view.frame.size.width/2 - toastLabel.frame.width/2, y: view.frame.size.height - 100)
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        },
        completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
}
