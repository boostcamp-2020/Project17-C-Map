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
        
        var leftMarkerLayers = [CALayer]()
        var rightMarkerLayers = [CALayer]()
        
        (0..<3).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            markerLayer.frame = CGRect(x: 0, y: 250 + (i * 150), width: 40, height: 40)
            markerLayer.contents = image.maskWithColor(color: .brown)?.cgImage
            markerLayer.contentsGravity = .resize
            
            leftMarkerLayers.append(markerLayer)
        }
        
        (0..<2).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            
            markerLayer.frame = CGRect(x: Int(view.frame.width) - 40, y: 250 + (i * 200), width: 40, height: 40)
            markerLayer.contents = image.maskWithColor(color: .red)?.cgImage
            markerLayer.contentsGravity = .resize
            
            rightMarkerLayers.append(markerLayer)
        }
        
        let endPosition = CGPoint(x: 200, y: 400)
        DispatchQueue.main.async {
            leftMarkerLayers.forEach { markerLayer in
                self.markerLayerAnimate(markerLayer: markerLayer, endPosition: endPosition)
            }
            
            rightMarkerLayers.forEach { markerLayer in
                self.markerLayerAnimate(markerLayer: markerLayer, endPosition: endPosition)
            }
        }
        
    }
    
    private func markerLayerAnimate(markerLayer: CALayer, endPosition: CGPoint) {
        
        let animation = AnimationController.splashMarkerAimation2(start: markerLayer.position, end: endPosition)
        
        CATransaction.begin()
        transparentUIView.layer.addSublayer(markerLayer)
        markerLayer.add(animation, forKey: "makerMove")
        CATransaction.setCompletionBlock {
            markerLayer.position = endPosition
            markerLayer.isHidden = false
        }
        CATransaction.commit()
    }

}
