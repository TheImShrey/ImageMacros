//
//  MacroSpawner.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import Metal
import CoreImage

protocol SwpannableMacro: NSObjectProtocol, Codable {
    var canvasSize: CGSize {get set}
    var allEntities: [any MacroEntity] {get}
}

class MacroSpawner {
    
    struct CoordinateSystem {
        static let bounds = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
    }
    
    private var spawnees: [Spawnee] = []
    
    private(set) var macro: SwpannableMacro
    
    init(macro: SwpannableMacro) {
        self.macro = macro
        updateSpawnees()
    }
    
    func set(macro: any SwpannableMacro) {
        self.macro = macro
        updateSpawnees()
    }
    
    private func updateSpawnees() {
        spawnees.removeAll()
        
        for entity in macro.allEntities {
            guard let spawnee = Spawnee(entity: entity) else {
                break
            }
            
            spawnees.append(spawnee)
        }
    }
    
    func spawnAll() -> CIImage {
        
        let orderedSpawnees = spawnees.sorted(by: { $0.entity.order < $1.entity.order })
        
        var compositedImage = CIImage()
        for spawnee in orderedSpawnees {
            let transformedImage = spawnee.image.transformed(by: getCompositeTransform(for: spawnee))
            compositedImage = transformedImage.composited(over: compositedImage)
        }
        
        return compositedImage
    }
    
    func getCompositeTransform(for spawnee: Spawnee) -> CGAffineTransform {
        
        let rotationTransform = CGAffineTransform(rotationAngle: spawnee.entity.rotation)
        
        var aspectRatioFactor = CGPoint(x: macro.canvasSize.width/spawnee.image.extent.size.width,
                                        y: macro.canvasSize.height/spawnee.image.extent.size.height)
        
        if (spawnee.entity as? ImageEntity)?.aspectFits == true || (spawnee.entity as? TextEntity) != nil {
            if spawnee.image.extent.size.width > spawnee.image.extent.size.height {
                aspectRatioFactor.y = macro.canvasSize.width/spawnee.image.extent.size.width
            } else {
                aspectRatioFactor.x = macro.canvasSize.height/spawnee.image.extent.size.height
            }
        }
        
        let normalizedScale = CGPoint(x: spawnee.entity.scale.x * aspectRatioFactor.x,
                                      y: spawnee.entity.scale.y * aspectRatioFactor.y)
        
        let scaleTransform = CGAffineTransform(scaleX: normalizedScale.x,
                                               y: normalizedScale.y)
        
        // MARK: Scale the translation values so that:
        // When x = 0: Image is starts from left most edge
        // When x = 1: Image is ends at right most edge
        // When y = 0: Image is starts from bottom most edge
        // When y = 1: Image is ends at top most edge
        // When x/y = 0: Image it at center
        let scaledCordinates = CGRect(origin: .zero,
                                      size: CGSize(width: macro.canvasSize.width - spawnee.image.extent.size.width * normalizedScale.x,
                                                   height: macro.canvasSize.height - spawnee.image.extent.size.height * normalizedScale.y))
        
        let oldXBounds = (CoordinateSystem.bounds.maxX - CoordinateSystem.bounds.minX)
        let scaledXBounds = (scaledCordinates.maxX - scaledCordinates.minX)
        let scaledXTranslation = (((spawnee.entity.translation.x - CoordinateSystem.bounds.minX) * scaledXBounds) / oldXBounds) + scaledCordinates.minX
        
        
        let oldYBounds = (CoordinateSystem.bounds.maxY - CoordinateSystem.bounds.minY)
        let scaledYBounds = (scaledCordinates.maxY - scaledCordinates.minY)
        let scaledYTranslation = (((spawnee.entity.translation.y - CoordinateSystem.bounds.minY) * scaledYBounds) / oldYBounds) + scaledCordinates.minY
        
        
        let translationTransform = CGAffineTransform(translationX: scaledXTranslation,
                                                     y: scaledYTranslation)
        
        let compositeTransform = CGAffineTransform.identity
            .concatenating(scaleTransform)
            .concatenating(rotationTransform)
            .concatenating(translationTransform)
        
        
        return compositeTransform
    }
}
