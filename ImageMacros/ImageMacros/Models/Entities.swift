//
//  Entities.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import Foundation
import UIKit

protocol MacroEntity: NSObjectProtocol, Hashable, Codable, Renderable {
    var order: Int {set get}
    var scale: CGPoint { get set }
    var translation: CGPoint { get set }
    var rotation: Double { get set }
}


class ImageEntity: NSObject, MacroEntity {
    internal init(path: String, order: Int, scale: CGPoint, translation: CGPoint, rotation: Double, aspectFits: Bool) {
        self.path = path
        self.order = order
        self.scale = scale
        self.translation = translation
        self.rotation = rotation
        self.aspectFits = aspectFits
    }
    
    var path: String
    var order: Int
    var scale: CGPoint
    var translation: CGPoint
    var rotation: Double
    var aspectFits: Bool
}


class TextEntity: NSObject, MacroEntity {
    internal init(contents: String, order: Int, scale: CGPoint, translation: CGPoint, rotation: Double, fontSize: Double, color: Color, backgroundColor: Color) {
        self.contents = contents
        self.order = order
        self.scale = scale
        self.translation = translation
        self.rotation = rotation
        self.fontSize = fontSize
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var contents: String
    var order: Int
    var scale: CGPoint
    var translation: CGPoint
    var rotation: Double
    var fontSize: Double
    var color: Color
    var backgroundColor: Color
}


class SolidColorEntity: NSObject, MacroEntity {
    internal init(order: Int, scale: CGPoint, translation: CGPoint, rotation: Double, color: Color) {
        self.order = order
        self.scale = scale
        self.translation = translation
        self.rotation = rotation
        self.color = color
    }
    
    var order: Int
    var scale: CGPoint
    var translation: CGPoint
    var rotation: Double
    var color: Color
}
