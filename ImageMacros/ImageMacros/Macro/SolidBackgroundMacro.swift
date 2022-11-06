//
//  MacroBackgroundMacro.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import CoreGraphics

class SolidBackgroundMacro: NSObject, SwpannableMacro {
    
    init(backgroundLayer: SolidColorEntity, canvasSize: CGSize) {
        self.backgroundLayer = backgroundLayer
        self.canvasSize = canvasSize
    }
    
    var canvasSize: CGSize
    
    var allEntities: [any MacroEntity] {
        imageLayers + textLayers + solidColorLayer + [backgroundLayer]
    }
    
    private(set) var imageLayers: [ImageEntity] = []
    private(set) var textLayers: [TextEntity] = []
    private(set) var solidColorLayer: [SolidColorEntity] = []
    
    func add(entity: ImageEntity) {
        imageLayers.append(entity)
    }
    
    func add(entity: TextEntity) {
        textLayers.append(entity)
    }
    
    func add(entity: SolidColorEntity) {
        solidColorLayer.append(entity)
    }
    
    var backgroundLayer: SolidColorEntity
}
