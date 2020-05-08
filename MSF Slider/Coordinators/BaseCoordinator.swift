//
//  AppCoordinator.swift
//  MSF Slider
//
//  Created by Franek on 28/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var isCompleted: (()->())?
    
    func start() {
        fatalError("Child should implement 'start'.")
    } 
}
