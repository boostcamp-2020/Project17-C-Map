//
//  SplashViewController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/09.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var globeImageView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    var mapViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewController = createMapViewController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMarkers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.presentMapViewController()
        }
    }
    
    private func configureMarkers() {
        loadingLabel.setTextWithTypeAnimation(inputText: "클러스터링 정보를 가져오는 중입니다......")
        
        guard let image = UIImage(named: "marker") else { return }
        
        var leftMarkerLayers = [CALayer]()
        var rightMarkerLayers = [CALayer]()
        
        (0..<3).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            markerLayer.frame = CGRect(x: 0, y: 250 + (i * 150), width: 50, height: 50)
            markerLayer.contents = image.maskWithColor(color: randomColor())?.cgImage
            markerLayer.contentsGravity = .resize
            
            leftMarkerLayers.append(markerLayer)
        }
        
        (0..<2).forEach { i in
            let markerLayer = CALayer()
            markerLayer.isHidden = true
            
            markerLayer.frame = CGRect(x: Int(view.frame.width) - 40, y: 250 + (i * 200), width: 50, height: 50)
            markerLayer.contents = image.maskWithColor(color: randomColor())?.cgImage
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

    private func createMapViewController() -> UIViewController {
        let dataManager = CoreDataStack.shared
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            identifier: "MapViewController",
            creator: { coder in
                return MapViewController(coder: coder, dataManager: dataManager)
            })
        
        return viewController
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

    private func randomColor() -> UIColor {
        let colors = [UIColor(named: "fiftyColor"),
                      UIColor(named: "hundredColor"),
                      UIColor(named: "thousandColor"),
                      UIColor(named: "fiveThousandColor"),
                      UIColor(named: "overFiveThousandColor"),
                      UIColor.systemRed,
                      UIColor.systemGreen]

        guard let color = colors.randomElement() else {
            return UIColor(red: 53/255, green: 60/255, blue: 130/255, alpha: 1)
        }
        guard let uiColor = color else {
            return UIColor(red: 53/255, green: 60/255, blue: 130/255, alpha: 1)
        }
        
        return uiColor
    }
    
}
