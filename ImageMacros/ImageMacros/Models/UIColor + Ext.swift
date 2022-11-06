//
//  UIColor + Ext.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import CoreImage
import UIKit

extension UIColor {
    var renderableColor: Color {
        let color = CIColor(color: self)
        return Color(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
}

