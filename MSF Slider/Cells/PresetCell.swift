//
//  PresetCell.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class PresetCell: UICollectionViewCell {
    
    var preset: PresetModel! {
        didSet {
            imageView.image = preset.image
        }
    }
    
    var imageBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1)
        view.layer.cornerRadius = 2.0
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        let inset:CGFloat = -30
        imageView.image = UIImage(named: "PlusImage")?.withAlignmentRectInsets(UIEdgeInsets(top: inset, left: inset, bottom: inset,right: inset))
        imageView.tintColor = .lighterOrange
        return imageView
        
    }()
    
    var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setContentView()
        setLabel()
        setImageBackgroundView()
        setImageView()
    }
    
    private func setContentView() {
       
        
    }
    
    private func setLabel(){
        self.contentView.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 3).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -3).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.font.pointSize + 10).isActive = true
    }
    
    private func setImageBackgroundView(){
        self.contentView.addSubview(imageBackgroundView)
        
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            imageBackgroundView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -0),
            imageBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            imageBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -0)])
    }
    
    private func setImageView(){
        self.imageBackgroundView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.imageBackgroundView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.imageBackgroundView.bottomAnchor, constant: -0),
            imageView.leadingAnchor.constraint(equalTo: self.imageBackgroundView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.imageBackgroundView.trailingAnchor, constant: -0)])
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
