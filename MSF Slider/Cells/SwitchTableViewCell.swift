//
//  TextFieldTableViewCell.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    var control: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setControl()
        setLabel()
    }
    
    private func setCell(){
        self.backgroundColor = .clear
//        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 90)])
    }
    
    private func setLabel() {
        textLabel?.textColor = .white
    }
    
    private func setControl() {
        self.contentView.addSubview(control)
        control.onTintColor = .lighterOrange
        NSLayoutConstraint.activate([
            control.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            control.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15)])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
