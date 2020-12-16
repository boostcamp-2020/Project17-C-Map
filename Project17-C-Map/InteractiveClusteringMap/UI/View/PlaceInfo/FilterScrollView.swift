//
//  FilterScrollView.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/11.
//

import UIKit

final class FilterScrollView: UIScrollView {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var filterButton: FilterButton!
    private var handler: ((String) -> Void)?
    private var selectedButton: UIButton?
    
    func configure(filterItems: [String], handler: @escaping ((String) -> Void)) {
        self.handler = handler
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        filterItems.forEach {
            guard let filterButton = makeFilterButton() else { return }
            filterButton.configure(text: $0)
            filterButton.addTarget(self, action: #selector(touchedHandler), for: .touchUpInside)
            
            stackView.addArrangedSubview(filterButton)
        }
    }
    
    @objc func touchedHandler(sender: UIButton) {
        selectedButton?.setTitleColor(.systemRed, for: .normal)
        selectedButton?.borderColor = .systemRed
        sender.setTitleColor(.systemBlue, for: .normal)
        sender.borderColor = .systemBlue
        selectedButton = sender
        handler?(sender.titleLabel?.text ?? "")
    }
    
}

extension FilterScrollView {
    
    private func makeFilterButton() -> FilterButton? {
        guard let view = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(NSKeyedArchiver.archivedData(withRootObject: filterButton!, requiringSecureCoding: false)) as? FilterButton else { return nil }
        
        return view
    }
    
}
