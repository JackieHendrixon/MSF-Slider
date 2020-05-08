//
//  MainCoordinator.swift
//  MSF Slider
//
//  Created by Franek on 07/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
    let router: RouterProtocol
    let preset: PresetModel
    
    init(router: RouterProtocol, preset: PresetModel) {
        self.router = router
        self.preset = preset
    }
    
    override func start() {
        let tabBarController = MainTabBarController()
        tabBarController.title = preset.name
        router.push(tabBarController, isAnimated: true, onNavigateBack: isCompleted)
    }
    
}
