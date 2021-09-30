//
//  CurrentLocationView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 30.09.2021.
//

import Foundation
import UIKit

class CurrentLocationView: UIView {
    
    var tapAction: (() -> Void)?
    
    private let currentLocationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "currentLocation")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCurrentLocationImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCurrentLocationImageView() {
        addSubview(currentLocationImage)
        let gestureReognizer = UITapGestureRecognizer(target: self, action: #selector(CurrentLocationClickAction))
        currentLocationImage.addGestureRecognizer(gestureReognizer)
        
        currentLocationImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    @objc private func CurrentLocationClickAction() {
        self.tapAction?()
    }
    
}
