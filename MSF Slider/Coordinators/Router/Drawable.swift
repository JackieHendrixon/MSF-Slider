//
//  Drawable.swift
//  MSF Slider
//
//  Created by Franek on 06/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

protocol Drawable {
    var viewController: UIViewController? {get}
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self}
}
