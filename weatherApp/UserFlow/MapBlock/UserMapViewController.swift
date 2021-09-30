//
//  UserMapViewController.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 30.09.2021.
//

import Foundation
import UIKit
import MapKit

class UserMapViewController: UIViewController {
    
    var onFinish: (() -> Void)?
    
    private lazy var backButton: BackButtonView = BackButtonView()
    private var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private let currentLocationImage: CurrentLocationView = CurrentLocationView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 176, green: 212, blue: 169)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.changeMapPointTo(CLLocation(latitude: 21.282778, longitude: -157.829444))
        }
    }
    
    private func setupViews() {
        setupBackButton()
        setupMapView()
        setupCurrentLocationImageView()
    }
    
    private func setupBackButton() {
        self.view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        backButton.backButtonAction = { [weak self] in
            self?.onFinish?()
        }
    }
    
    private func setupMapView() {
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupCurrentLocationImageView() {
        self.view.addSubview(currentLocationImage)
        currentLocationImage.tapAction = { [weak self] in
            self?.currentLocationClickAction()
        }
        
        currentLocationImage.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(50)
        }
    }
    
    private func currentLocationClickAction() {
        print("action")
    }
    
    func changeMapPointTo(_ location: CLLocation) {
        self.mapView.centerToLocation(location)
    }
    
}
