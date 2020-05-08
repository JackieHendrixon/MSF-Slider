//
//  PresetModel.swift
//  MSF Slider
//
//  Created by Franek on 04/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit

struct PresetModel {
    var name: String! {
        didSet{
            print(name)
        }
    }
    var date: Date! {
        didSet{
            print(date)
        }
    }
    var image: UIImage!
}
