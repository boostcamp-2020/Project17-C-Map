//
//  OnboardingViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        UserDefaultsManager.shared.isLaunched = skipButton.isSelected
        dismiss(animated: true)
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
        skipButton.isSelected = !sender.isSelected
    }
    
}
