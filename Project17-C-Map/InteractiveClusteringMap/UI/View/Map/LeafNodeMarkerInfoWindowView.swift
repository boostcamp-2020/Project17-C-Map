//
//  CustomInfoWindowView.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/08.
//

import UIKit

class LeafNodeMarkerInfoWindowView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureNib()
    }
    
    init() {
        super.init(frame: .zero)
        configureNib()
    }
    
    var viewFromNib: UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LeafNodeMarkerInfoWindowView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureNib() {
        guard let view = viewFromNib else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func configureContent(title: String, category: String) {
        titleLabel.text = title
        categoryLabel.text = category
        
        titleLabel.sizeToFit()
        categoryLabel.sizeToFit()
        
        let width = titleLabel.frame.size.width + categoryLabel.frame.size.width + 178
        frame = CGRect(x: 0, y: 0, width: width, height: 100)
        layoutIfNeeded()
    }
    
}
