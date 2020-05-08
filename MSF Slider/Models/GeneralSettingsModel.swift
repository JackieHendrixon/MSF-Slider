//
//  GeneralSettingsModel.swift
//  MSF Slider
//
//  Created by Franek on 05/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation

class GeneralSettingsModel  {
    enum ConnectToDevice: Int{
        case auto, manually;
    }
    var deviceName: String! = "MSFSlider"{
        didSet{
            print(deviceName)
        }
    }
    var connectToDevice: ConnectToDevice = .auto{
        didSet{
            print(connectToDevice.rawValue)
        }
    }
    var instantCalibration: Bool = true {
        didSet{
            print(instantCalibration)
        }
    }
}
