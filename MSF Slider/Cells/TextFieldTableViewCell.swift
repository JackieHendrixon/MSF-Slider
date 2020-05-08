//
//  TextFieldTableViewCell.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    var textField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setTextField()
        setLabel()
    }
    
    private func setCell(){
        self.backgroundColor = .clear

    }
    
    private func setLabel() {
        textLabel?.textColor = .white
    }
    
    private func setTextField() {
        self.contentView.addSubview(textField)
        textField.backgroundColor = .gray
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            textField.widthAnchor.constraint(equalToConstant: 100),
            textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
