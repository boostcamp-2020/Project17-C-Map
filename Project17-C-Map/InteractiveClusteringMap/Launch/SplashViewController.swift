//
//  SplashViewController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/09.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var transparentUIView: UIView!
    @IBOutlet weak var globeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMarkers()
    }
    
    private func configureMarkers() {
        guard let image = UIImage(named: "marker") else { return }
        
        let markerLayer = CALayer()
        markerLayer.frame = CGRect(x: 0, y: 300, width: 40, height: 40)
        
        markerLayer.contents = image.maskWithColor(color: .brown)?.cgImage
        markerLayer.contentsGravity = .resize
        let endPosition = CGPoint(x: markerLayer.position.x + 200, y: markerLayer.position.y + 100)
        let animation = AnimationController.splashMarkerAimation(start: markerLayer.position, end: endPosition)
        
        transparentUIView.layer.addSublayer(markerLayer)
        CATransaction.begin()
        markerLayer.add(animation, forKey: "makerMove")
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        
    }


}
