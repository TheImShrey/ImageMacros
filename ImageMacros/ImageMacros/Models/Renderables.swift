//
//  Renderable.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import CoreImage

protocol Renderable: NSObjectProtocol {
    func buildRenderable() -> CIImage?
}


