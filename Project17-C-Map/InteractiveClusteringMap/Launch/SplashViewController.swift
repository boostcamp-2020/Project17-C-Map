//
//  SplashViewController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/09.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        animation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        animation()
    }
    
    private func animation() {
        let markerLayer = CALayer()
        markerLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 40)
        markerLayer.contents = UIImage(named: "marker")
        
        self.view.layer.addSublayer(markerLayer)
    }

}
