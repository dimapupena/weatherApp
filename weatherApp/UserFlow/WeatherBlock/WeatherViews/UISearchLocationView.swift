//
//  UISearchLocationView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 10.09.2021.
//

import Foundation
import UIKit
import SnapKit

class UISearchLocationView: UIView {
    
    private let locationTableViewCell = "TableLocationViewCell"
    
    lazy private var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(UISearchLocationTableViewCell.self, forCellReuseIdentifier: locationTableViewCell)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(locationTableView)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        locationTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension UISearchLocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationTableViewCell) as! UISearchLocationTableViewCell
        return cell
    }
    
    
}
