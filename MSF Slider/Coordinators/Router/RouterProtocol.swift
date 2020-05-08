//
//  RouterProtocol.swift
//  MSF Slider
//
//  Created by Franek on 06/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

typealias NavigationBackClosure = (() -> ())

protocol RouterProtocol: class {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
}
