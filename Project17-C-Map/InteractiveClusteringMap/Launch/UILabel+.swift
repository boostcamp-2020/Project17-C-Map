//
//  UILabel+.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/11.
//

import UIKit

extension UILabel {
    
    func setTextWithTypeAnimation(inputText: String) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            for character in inputText {
                DispatchQueue.main.async {
                    self.text?.append(character)
                }
                Thread.sleep(forTimeInterval: 0.1)
            }
        }

        if let task = writingTask {
            let queue = DispatchQueue(label: "typingSpeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }

}
