//
//  OnboardingViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardImageView: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        print(skipButton.isSelected)
        FirstLaunchDetector.shared.isLaunched = skipButton.isSelected
        dismiss(animated: true)
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(skipButton.isSelected)
    }
    
}
