//
//  BackButtonView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 06.09.2021.
//

import Foundation
import SnapKit
import UIKit

class BackButtonView: UIView {
    
    var backButtonAction: (() -> Void)?
    
    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "leftArrow")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSelfView()
        setupBackImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelfView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        self.addGestureRecognizer(gestureRecognizer)
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
    
    private func setupBackImageView() {
        addSubview(backImageView)
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    @objc private func backButtonClicked() {
        self.backButtonAction?()
    }
    
}
