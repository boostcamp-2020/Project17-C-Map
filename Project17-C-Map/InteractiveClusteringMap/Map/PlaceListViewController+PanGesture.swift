//
//  PlaceListViewController+PanGesture.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/10.
//

import UIKit

extension PlaceListViewController: UIGestureRecognizerDelegate {
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        let y = view.frame.minY
        if (y + translation.y >= Boundary.fullView) && (y + translation.y <= Boundary.partialView) {
            view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        
        if recognizer.state == .ended {
            var duration =
                velocity.y < 0
                ? Double((y - Boundary.fullView) / -velocity.y)
                : Double((Boundary.partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: [.allowUserInteraction],
                           animations: { [weak self] in
                            guard let self = self else { return }
                            
                            if  velocity.y >= 0 {
                                self.view.frame = CGRect(x: 0,
                                                         y: Boundary.partialView,
                                                         width: self.view.frame.width,
                                                         height: self.view.frame.height)
                            } else {
                                self.view.frame = CGRect(x: 0,
                                                         y: Boundary.fullView,
                                                         width: self.view.frame.width,
                                                         height: self.view.frame.height)
                            }
                           }, completion: { [weak self] _ in
                            guard let self = self else { return }
                            
                            if velocity.y < 0 {
                                self.collectionView.isScrollEnabled = true
                            }
                           })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = (gestureRecognizer as? UIPanGestureRecognizer) else {
            return false
        }
        
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == Boundary.fullView && direction > 0) || (y == Boundary.partialView) {
            collectionView.isScrollEnabled = false
        } else {
            collectionView.isScrollEnabled = true
        }
        
        return false
    }
    
    enum Boundary {
        static let fullView: CGFloat = 140
        static let partialView: CGFloat = UIScreen.main.bounds.height - 140
    }
}

