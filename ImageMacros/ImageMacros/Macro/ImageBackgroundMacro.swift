//
//  ImageBackgroundMacro.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import Foundation


class ImageBackgroundMacro: NSObject, Codable, SwpannableMacro {
    
    init(backgroundLayer: ImageEntity, canvasSize: CGSize) {
        self.backgroundLayer = backgroundLayer
        self.canvasSize = canvasSize
    }
    
    var canvasSize: CGSize
 
    private(set) var imageLayers: [ImageEntity] = []
    private(set) var textLayers: [TextEntity] = []
    private(set) var solidColorLayer: [SolidColorEntity] = []
    
    var allEntities: [any MacroEntity] {
        imageLayers + textLayers + solidColorLayer + [backgroundLayer]
    }
    
    
    func add(entity: ImageEntity) {
        imageLayers.append(entity)
    }
    
    func add(entity: TextEntity) {
        textLayers.append(entity)
    }
    
    func add(entity: SolidColorEntity) {
        solidColorLayer.append(entity)
    }
    
    var backgroundLayer: ImageEntity
}
