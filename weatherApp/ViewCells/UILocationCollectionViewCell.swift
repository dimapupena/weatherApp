//
//  UILocationCollectionViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 28.08.2021.
//

import Foundation
import UIKit
import SnapKit

class UILocationCollectionViewCell: UICollectionViewCell {
    
    private var location: UserLocation? {
        didSet {
            locationName.text = location?.Name
        }
    }
    
    private let locationName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSelf()
        setupLocationName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(location: String) {
        self.location = UserLocation(Name: location)
    }
    
    func getLocation() -> UserLocation? {
        return self.location
    }
    
    private func setupSelf() {
        self.backgroundColor = UIColor(red: 173, green: 135, blue: 135)
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    private func setupLocationName() {
        addSubview(locationName)
        
        locationName.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
