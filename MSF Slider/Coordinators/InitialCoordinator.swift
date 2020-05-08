//
//  InitialCoordinator.swift
//  MSF Slider
//
//  Created by Franek on 29/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class InitialCoordinator: BaseCoordinator {
    let router: RouterProtocol
    var generalSettings: GeneralSettingsModel!
    
    init(router: RouterProtocol) {
        self.router = router
        super.init()
        loadGeneralSettings()
    }
    
    
    override func start() {
        let testVC = TestViewController()
      
        
        router.push(testVC, isAnimated: true, onNavigateBack: nil)
    }
//    override func start() {
//        let initialVC = InitialViewController(nibName: nil, bundle: nil)
//        initialVC.title = "Presets"
//        initialVC.delegate = self
//        self.router.push(initialVC, isAnimated: true, onNavigateBack: isCompleted)
//    }
    
    func loadGeneralSettings(){
        let settings = GeneralSettingsModel()
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "gs"){
        settings.deviceName = defaults.string(forKey: "gs_device_name")
        settings.connectToDevice = (defaults.integer(forKey: "gs_connect_to_device") == 0) ? .auto : .manually
        settings.instantCalibration = defaults.bool(forKey: "gs_instant_calibration")
        }
        self.generalSettings = settings
    }
    
    func saveGeneralSettings(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "gs")
        defaults.set(generalSettings.deviceName, forKey: "gs_device_name")
        defaults.set(generalSettings.connectToDevice.rawValue, forKey: "gs_connect_to_device")
        defaults.set(generalSettings.instantCalibration, forKey: "gs_instant_calibration")
    }
    
    
    
}

extension InitialCoordinator: InitialViewControllerDelegate{
    func navigateToSettings(){
        let generalSettingsVC = GeneralSettingsViewController()
        generalSettingsVC.title = "General Settings"
        generalSettingsVC.generalSettings = generalSettings
        self.router.push(generalSettingsVC, isAnimated: true) {
            self.saveGeneralSettings()
            self.isCompleted?()
        }
    }
    
    func navigateTo(preset: PresetModel) {
        let mainCoordinator = MainCoordinator(router: self.router, preset: preset)
        self.store(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
}

