//
//  TextFieldTableViewCell.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class SegmentedControlTableViewCell: UITableViewCell {
    
    var control: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["",""])
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setControl()
        setLabel()
    }
    
    private func setCell(){
        self.backgroundColor = .clear

    }
    
    private func setLabel() {
        textLabel?.textColor = .white
    }
    
    private func setControl() {
        self.contentView.addSubview(control)
        
        NSLayoutConstraint.activate([
            control.heightAnchor.constraint(equalToConstant: 25),
            control.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
//            control.widthAnchor.constraint(equalToConstant: 100),
            control.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
