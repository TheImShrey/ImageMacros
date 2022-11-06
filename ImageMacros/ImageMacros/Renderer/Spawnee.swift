//
//  Spawnee.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import CoreImage


struct Spawnee {
    let image: CIImage
    let entity: any MacroEntity
    
    init?(entity: any MacroEntity) {
        guard let image = entity.buildRenderable() else {
            return nil
        }
        
        self.image = image
        self.entity = entity
    }
    
    init(entity: any MacroEntity, image: CIImage) {
        self.image = image
        self.entity = entity
    }
    }
