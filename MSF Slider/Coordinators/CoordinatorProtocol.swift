//
//  Coordinator.swift
//  MSF Slider
//
//  Created by Franek on 28/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {$0 !== coordinator}
    }
}
