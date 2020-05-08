//
//  InitialViewController.swift
//  MSF Slider
//
//  Created by Franek on 29/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    var presets: [PresetModel] = [PresetModel(name: "Preset", date: Date(), image: nil ), PresetModel(name: "Preset2", date: Date(), image: nil )]
    
    var rightBarItem: UIBarButtonItem!
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(PresetCell.self, forCellWithReuseIdentifier: "presetCell")
        cv.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        return cv
    }()
    
    weak var delegate: InitialViewControllerDelegate?
    
    override func viewDidLoad() {
        self.title = "Presets"
        
        setRightBarItem()
        setCollectionView()
    }
    
    private func setCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaTopAnchor, constant: 0).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor, constant: 0).isActive = true
    }
    
    private func setRightBarItem(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "SettingsIcon"), for: .normal)

        
        button.addTarget(self, action: #selector(touchUpRightBarItem), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDownRightBarItem), for: .touchDown)
        rightBarItem = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
        
        rightBarItem.customView!.transform = CGAffineTransform(scaleX: 0,y: 0)
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 10,
                       options: .curveLinear,
                       animations: {
                        self.rightBarItem.customView!.transform = CGAffineTransform.identity
                        },
                       completion: nil)
        
    }
    
    @objc private func touchUpRightBarItem(){
        if let delegate = self.delegate {
            delegate.navigateToSettings()
        }
        
    }
    @objc private func touchDownRightBarItem(){
        self.rightBarItem.customView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2 )
        UIView.animate(withDuration: 0.2, animations: {
            self.rightBarItem.customView!.transform = CGAffineTransform.identity
        })
        
    }
    
}

extension InitialViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 15, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presetCell", for: indexPath) as! PresetCell
        if (indexPath.item == 0) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
            cell.imageBackgroundView.addGestureRecognizer(tap)
            cell.label.text = "New preset"
            return cell

        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        cell.imageBackgroundView.addGestureRecognizer(tap)
        cell.label.text = presets[indexPath.item-1].name
        
        return cell
    }
    
    @objc func didTapCell(_ sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: tapLocation)
        
        let preset = (indexPath!.item == 0) ? PresetModel(name: "HolaHolaSeniorita", date: Date(), image: nil) : presets[indexPath!.item-1]
        
        self.delegate?.navigateTo(preset: preset)
    }
}

protocol InitialViewControllerDelegate: class {
    func navigateToSettings()
    
    func navigateTo(preset: PresetModel)
}
