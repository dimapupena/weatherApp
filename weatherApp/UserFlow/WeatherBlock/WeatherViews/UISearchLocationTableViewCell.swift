//
//  UISearchLocationTableViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 10.09.2021.
//

import Foundation
import UIKit

class UISearchLocationTableViewCell: UITableViewCell {
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .lightGray
        self.selectionStyle = .none
        
        setupViews()
    }
    
    func updateLocation(_ location: SearchLocation) {
        self.locationNameLabel.text = location.name
    }
    
    private func setupViews() {
        setupLocationNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLocationNameLabel() {
        addSubview(locationNameLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
