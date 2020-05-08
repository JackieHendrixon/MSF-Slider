//
//  GeneralSettingsViewController.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class GeneralSettingsViewController: UIViewController {
    
    weak var generalSettings: GeneralSettingsModel!
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.allowsSelection = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaTopAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor)])
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
        tableView.register(SegmentedControlTableViewCell.self, forCellReuseIdentifier: "segmentedControlCell")
    }
}

extension GeneralSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Slider device"
        case 1:
            return "About"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.layer.backgroundColor = UIColor.darkGray.cgColor
        header.backgroundView?.backgroundColor = .clear
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lighterOrange
        header.backgroundView?.addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 2),
            line.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            line.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 0),
            line.widthAnchor.constraint(equalToConstant: 150)])
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                let deviceNameCell  = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
                deviceNameCell.textLabel?.text = "Device Name"
                deviceNameCell.textField.placeholder = generalSettings.deviceName
                deviceNameCell.textField.delegate = self
                cell = deviceNameCell
                
            case 1:
                let connectToDeviceCell = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell", for: indexPath) as! SegmentedControlTableViewCell
                connectToDeviceCell.textLabel?.text = "Connect to device"
                connectToDeviceCell.control.setTitle("Auto", forSegmentAt: 0)
                connectToDeviceCell.control.isHidden = false
                connectToDeviceCell.control.setTitle("Manually", forSegmentAt: 1)
                connectToDeviceCell.control.selectedSegmentIndex = generalSettings.connectToDevice.rawValue
                connectToDeviceCell.control.addTarget(self, action: #selector(connectToDeviceValueChanged(_:)), for: .valueChanged)
                cell = connectToDeviceCell
                break
            case 2:
                let instantCalibrationCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
                
                instantCalibrationCell.textLabel?.text = "Instant calibration"
                instantCalibrationCell.control.isOn = generalSettings.instantCalibration
                instantCalibrationCell.control.addTarget(self, action: #selector(instantCalibrationValueChanged(_:)), for: .valueChanged)
                cell = instantCalibrationCell
            default:
                cell = UITableViewCell()
                break
                
            }
        default:
            cell = UITableViewCell()
            break
           
        }  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func connectToDeviceValueChanged(_ sender: UISegmentedControl) {
        generalSettings.connectToDevice =  (sender.selectedSegmentIndex == 0) ? .auto : .manually
    }
    @objc func instantCalibrationValueChanged(_ sender: UISwitch) {
        generalSettings.instantCalibration = sender.isOn
        
    }
}

extension GeneralSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        generalSettings.deviceName = textField.text
        textField.endEditing(true)
        textField.placeholder = textField.text
        textField.text = ""
        return true
    }
}

