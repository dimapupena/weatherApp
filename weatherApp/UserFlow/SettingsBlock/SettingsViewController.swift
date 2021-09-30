//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 05.09.2021.
//

import Foundation
import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    
    var onFinish: (() -> Void)?
    
    private var viewModel: SettingsViewModable?
    
    private lazy var backButton: BackButtonView = BackButtonView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBlue
        
        setupSelf()
        setupBackButton()
    }
    
    private func setupSelf() {
        self.viewModel = SettingsViewModel()
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
    
}
