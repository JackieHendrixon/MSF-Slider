//
//  MainTabBarController.swift
//  MSF Slider
//
//  Created by Franek on 07/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.barTintColor = .barGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let joystickVC = JoystickTabViewController()
        joystickVC.view.backgroundColor = .green
        joystickVC.tabBarItem = UITabBarItem(title: "Joysticks", image: UIImage(named: "JoystickTabBarItem"), tag: 0)
        
        let sequenceVC = SequenceTabViewController()
        sequenceVC.view.backgroundColor = .blue
        sequenceVC.tabBarItem =  UITabBarItem(title: "Sequence", image: UIImage(named: "SequenceTabBarItem"), tag: 1)
        
        
        self.viewControllers = [joystickVC, sequenceVC]
    }
}


