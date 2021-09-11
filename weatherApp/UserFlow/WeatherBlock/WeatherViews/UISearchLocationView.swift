//
//  UISearchLocationView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 10.09.2021.
//

import Foundation
import UIKit
import SnapKit

protocol UISearchLocationViewDelegate: AnyObject {
    func locationWasSelected(_ location: SearchLocation)
    func finishedUseKeynoard()
}

class UISearchLocationView: UIView {
    
    weak var delegate: UISearchLocationViewDelegate?
    
    private let locationTableViewCell = "TableLocationViewCell"
    private var searchedLocation: [SearchLocation] = []
    
    lazy private var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = false
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
    
    func updateLocation(_ locations: [SearchLocation]) {
        self.searchedLocation = locations
        locationTableView.reloadData()
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
        return searchedLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationTableViewCell) as! UISearchLocationTableViewCell
        cell.updateLocation(searchedLocation[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.locationWasSelected(searchedLocation[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.finishedUseKeynoard()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
