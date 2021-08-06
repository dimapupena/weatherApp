//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import UIKit
import Foundation

// viewController
// protocol
// ref to presenter

enum CollectionCellSize: Int {
    case collectionHeight = 150
    case collectionWidth = 100
}

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func updateWeahter(with weather: Weather?)
    func updateWeahterWithError(with error: Error?)
}

class WeatherViewController: UIViewController, AnyView {
    var presenter: AnyPresenter?
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 15
        textField.placeholder = "Enter city name"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderColor = .init(red: 125, green: 22, blue: 15, alpha: 1.0)
        textField.layer.borderWidth = 2
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Find", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UIWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "weatherCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let weatherDetailsView: WeatherDetailsView = {
        let view = WeatherDetailsView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 191, green: 181, blue: 180)
        
        setupTextField()
        setupSearchButton()
        setupCollectionView()
        setupWeatherDetailsView()
    }
    
    func setupTextField() {
        self.view.addSubview(searchTextField)
        
        searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupSearchButton() {
        self.view.addSubview(searchButton)
        
        searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        searchButton.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 20).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.topAnchor.constraint(equalTo: self.searchButton.bottomAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: CGFloat(CollectionCellSize.collectionHeight.rawValue)).isActive = true
    }
    
    func setupWeatherDetailsView() {
        self.view.addSubview(weatherDetailsView)
        
        weatherDetailsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        weatherDetailsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        weatherDetailsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        weatherDetailsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func updateWeahter(with weather: Weather?) {
        print("update view with weather")
    }

    func updateWeahterWithError(with error: Error?) {
        print("update view with error")
    }
    
    @objc private func searchButtonClicked() {
        print("fetching data")
        self.presenter?.fetchWeather()
    }
    
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! UIWeatherCollectionViewCell
        cell.updateweatherData(city: "Paris", temperature: "23", condition: "top")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionCellSize.collectionWidth.rawValue, height: CollectionCellSize.collectionHeight.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
