//
//  AlertController.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/05.
//

import Foundation
import UIKit

class MapAlertController {
    
    private let alertType: AlertType
    private let okHandler: ((UIAlertAction) -> Void)?
    private let cancelHandler: ((UIAlertAction) -> Void)?
    
    init(alertType: AlertType, okHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        self.alertType = alertType
        self.okHandler = okHandler
        self.cancelHandler = cancelHandler
    }
    
    func createAlertController() -> UIAlertController {
        switch alertType {
        case .delete:
            return createDeleteAlertController(title: Name.deleteTitle, message: Name.deleteMessage)
        case .add:
            return createAddAlertController(title: Name.addTitle, message: Name.addMessage)
        }
    }
    
    private func createAddAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            textField.placeholder = "장소 이름"
        }
        
        return alert
    }
    
    private func createDeleteAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive, handler: okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
}

extension MapAlertController {
    private enum Name {
        static let deleteTitle: String = "마커 삭제"
        static let deleteMessage: String = "해당 위치의 마커를 삭제하시겠습니까?"
        static let addTitle: String = "마커 추가"
        static let addMessage: String = "해당 위치에 마커를 추가하시겠습니까? \n장소의 이름을 입력해 주세요."
    }
    
    enum AlertType {
        case delete
        case add
    }
}
