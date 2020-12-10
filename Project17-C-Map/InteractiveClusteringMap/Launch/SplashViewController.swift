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
    private var mapViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewController = createMapViewController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMarkers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
            self.presentMapViewController()
        }
    }
    
    private func configureMarkers() {
        guard let image = UIImage(named: "marker") else { return }
        
        var leftMarkerLayers = [CALayer]()
        var rightMarkerLayers = [CALayer]()
        
        (0..<3).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            markerLayer.frame = CGRect(x: 0, y: 250 + (i * 150), width: 50, height: 50)
            markerLayer.contents = image.maskWithColor(color: .brown)?.cgImage
            markerLayer.contentsGravity = .resize
            
            leftMarkerLayers.append(markerLayer)
        }
        
        (0..<2).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            
            markerLayer.frame = CGRect(x: Int(view.frame.width) - 40, y: 250 + (i * 200), width: 50, height: 50)
            markerLayer.contents = image.maskWithColor(color: .red)?.cgImage
            markerLayer.contentsGravity = .resize
            
            rightMarkerLayers.append(markerLayer)
        }
        
        let endPosition = CGPoint(x: 200, y: 400)
        
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
        var animations: [(CGPoint, CGPoint) -> (CAAnimationGroup)] = [AnimationController.splashMarkerAnimation1, AnimationController.splashMarkerAnimation2, AnimationController.splashMarkerAnimation3]
        animations.shuffle()
        guard let animation = animations.first else { return }
        
        let randomAnimation = animation(markerLayer.position, endPosition)
        CATransaction.begin()
        transparentUIView.layer.addSublayer(markerLayer)
        markerLayer.add(randomAnimation, forKey: "makerMove")
        CATransaction.setCompletionBlock {
            markerLayer.position = endPosition
            markerLayer.isHidden = false
        }
        CATransaction.commit()
    }

    private func createMapViewController() -> UIViewController {
        let dataManager = CoreDataStack.shared
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            identifier: "MapViewController",
            creator: { coder in
                return MapViewController(coder: coder, dataManager: dataManager)
            })
        
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
       
    }
    
    func presentMapViewController() {
        guard let mapViewController = mapViewController else { return }
        let window = self.view.window
        self.dismiss(animated: true) {
            window?.rootViewController = mapViewController
            window?.makeKeyAndVisible()
        }
    }
    
}
