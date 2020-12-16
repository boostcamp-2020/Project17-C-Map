//
//  SplashViewController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/09.
//

import UIKit
import NMapsMap

class SplashViewController: UIViewController {
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var globeImageView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    var mapViewController: UIViewController?
    
    init?(coder: NSCoder, mapViewController: MapViewController) {
        super.init(coder: coder)
        self.mapViewController = mapViewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMarkers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.presentMapViewController()
        }
    }
    
    private func configureMarkers() {
        loadingLabel.setTextWithTypeAnimation(inputText: Name.loadingLabelText)
        
        var leftMarkerLayers = [CALayer]()
        var rightMarkerLayers = [CALayer]()
        
        (0..<3).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            let markerYPosition = 250 + (i * 150)
            markerLayer.frame = CGRect(x: 0, y: markerYPosition, width: 40, height: 53)
            markerLayer.contents = randomColorMarker()
            markerLayer.contentsGravity = .resize
            
            leftMarkerLayers.append(markerLayer)
        }
        
        (0..<2).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            let markerYPosition =  250 + (i * 200)
            markerLayer.frame = CGRect(x: Int(view.frame.width) - 40, y: markerYPosition, width: 40, height: 53)
            markerLayer.contents = randomColorMarker()
            markerLayer.contentsGravity = .resize
            
            rightMarkerLayers.append(markerLayer)
        }
        
        let endPosition = CGPoint(x: globeImageView.layer.position.x + 20,
                                  y: globeImageView.layer.position.y - 118)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            leftMarkerLayers.forEach { markerLayer in
                self.markerLayerAnimate(markerLayer: markerLayer, endPosition: endPosition)
            }
            
            rightMarkerLayers.forEach { markerLayer in
                self.markerLayerAnimate(markerLayer: markerLayer, endPosition: endPosition)
            }
        }
        
    }
    
    private func markerLayerAnimate(markerLayer: CALayer, endPosition: CGPoint) {
        var animations: [(CGPoint, CGPoint) -> (CAAnimationGroup)] = [
            AnimationController.splashMarkerAnimation1,
            AnimationController.splashMarkerAnimation2,
            AnimationController.splashMarkerAnimation3]
        animations.shuffle()
        guard let animation = animations.first else { return }
        
        let randomAnimation = animation(markerLayer.position, endPosition)
        CATransaction.begin()
        transparentView.layer.addSublayer(markerLayer)
        markerLayer.add(randomAnimation, forKey: "makerMove")
        CATransaction.setCompletionBlock {
            markerLayer.position = endPosition
            markerLayer.isHidden = false
        }
        CATransaction.commit()
    }
    
    private func presentMapViewController() {
        guard let mapViewController = mapViewController,
              let window = self.view.window else {
            return
        }
        
        self.dismiss(animated: true) {
            window.rootViewController = mapViewController
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func randomColorMarker() -> CGImage? {
        let markers = [NMF_MARKER_IMAGE_RED,
                       NMF_MARKER_IMAGE_LIGHTBLUE,
                       NMF_MARKER_IMAGE_BLUE,
                       NMF_MARKER_IMAGE_PINK,
                       NMF_MARKER_IMAGE_GREEN,
                       NMF_MARKER_IMAGE_YELLOW
        ]
        
        return markers.randomElement()?.image.cgImage
    }
    
}

extension SplashViewController {
    enum Name {
        static let loadingLabelText = "클러스터링 정보를 가져오는 중입니다……"
    }
}
