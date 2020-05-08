//
//  SettingsCoordinator.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class GeneralSettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController!
    
    weak var delegate: BackToInitialVCDelegate?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let generalSettingsVC = GeneralSettingsViewController()
        generalSettingsVC.title = "General Settings"
        presenter.pushViewController(generalSettingsVC, animated: true)
    }
    
}

protocol BackToInitialVCDelegate: AnyObject {
    func navigateBackToInitialVC(coordinator: Coordinator)
}
