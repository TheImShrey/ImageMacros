//
//  Renderer.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import CoreImage
import MetalKit
import Metal

class Renderer: NSObject {
    static let shared = Renderer()
    
    let ciContext: CIContext
    let commandQueue: MTLCommandQueue
    let device: MTLDevice
    let defaultColorSpace: CGColorSpace
    
    private override init() {
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
        ciContext = CIContext(mtlCommandQueue: commandQueue)
        defaultColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        
        super.init()
    }
    
    func render(_ image: CIImage, into drawable: CAMetalDrawable, having colorSpace: CGColorSpace? = nil, bounds: CGRect? = nil) {
        
        guard let commandBuffer = Renderer.shared.commandQueue.makeCommandBuffer() else {
            debugPrint("Unable to get commandBuffer")
            return
        }
        
        let bounds = bounds ?? CGRect(origin: .zero,
                                      size: CGSize(width: drawable.texture.width,
                                                   height: drawable.texture.height))
        
        let colorSpace = colorSpace ?? self.defaultColorSpace
        
        Renderer.shared.ciContext.render(image,
                                         to: drawable.texture,
                                         commandBuffer: commandBuffer,
                                         bounds: bounds,
                                         colorSpace: colorSpace)
        
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
}


