//
//  Entities + Ext.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import Foundation
import UIKit


extension ImageEntity {
    
    func buildRenderable() -> CIImage? {
        
        guard let url = URL(string: path) else {
            debugPrint("Invalid path")
            return nil
        }
        
        // TODO: Later can be loaded in async
        guard var image = CIImage(contentsOf: url) else {
            debugPrint("Invalid path: \(path)")
            return nil
        }
        
        return image
    }
}


extension TextEntity {
    
    func buildRenderable() -> CIImage? {
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: color.uiColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.backgroundColor: backgroundColor.uiColor
        ]
        
        let textSize = contents.size(withAttributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
        contents.draw(at: CGPoint.zero, withAttributes: attributes)
        let rawImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let rawImage = rawImage else {
            debugPrint("Unable to build image from text")
            return nil
        }
        
        guard var image = CIImage(image: rawImage) else {
            debugPrint("Unable to build ciimage from uiimage")
            return nil
        }
        
        return image
    }
}


extension SolidColorEntity {
    
    func buildRenderable() -> CIImage? {
        
        let solidCIColor = CIColor(color: color.uiColor)
        
        var image = CIImage(color: solidCIColor)
        
        return image
    }
}
