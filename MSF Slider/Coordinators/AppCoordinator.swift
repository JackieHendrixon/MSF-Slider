//
//  AppCoordinator.swift
//  MSF Slider
//
//  Created by Franek on 28/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let rootNavigationController: UINavigationController
    private let router: Router

    init(window: UIWindow){
        self.window = window
        self.rootNavigationController = UINavigationController()
        self.router = Router(navigationController: rootNavigationController)
        super.init()
        
        self.window.tintColor = .lighterOrange
        self.window.backgroundColor = .backgroundGray
        UINavigationBar.appearance().barTintColor = .barGray
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
  
    override func start() {

        let initialCoordinator = InitialCoordinator(router: self.router)
        self.store(coordinator: initialCoordinator)
        initialCoordinator.start()

        window.rootViewController = self.rootNavigationController
        window.makeKeyAndVisible()

        initialCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: initialCoordinator)
        }
    }
}
