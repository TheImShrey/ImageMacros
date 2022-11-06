//
//  File.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//
import UIKit


class HardCodings {
    
    static let IMG1 = "https://media.istockphoto.com/id/1322277517/photo/wild-grass-in-the-mountains-at-sunset.jpg?s=612x612&w=0&k=20&c=6mItwwFFGqKNKEAzv0mv6TaxhLN3zSE43bWmFN--J5w="
    
    static let IMG2 = "https://static.remove.bg/remove-bg-web/ea3c274e1b7f6fbbfe93fad8b2b13d7ef352f09c/assets/start_remove-c851bdf8d3127a24e2d137a55b1b427378cd17385b01aec6e59d5d4b5f39d2ec.png"

    
    static var BasicTestMacro: SwpannableMacro {
        
        let image1 = ImageEntity(path: IMG1,
                                 order: 1,
                                 scale: CGPoint(x: 1, y: 1),
                                 translation: CGPoint(x: 0.5, y: 0.5),
                                 rotation: 0,
                                 aspectFits: true)
        
        
        let image2 = ImageEntity(path: IMG2,
                                 order: 2,
                                 scale: CGPoint(x: 1, y: 1),
                                 translation: CGPoint(x: 0.5, y: 0.5),
                                 rotation: 0,
                                 aspectFits: true)
        
        
        let textEntity = TextEntity(contents: "Hello there, 🚀 !!!",
                                order: 3,
                                scale: CGPoint(x: 1, y: 1),
                                translation: CGPoint(x: 0.5, y: 1),
                                rotation: 0,
                                fontSize: 14,
                                color: UIColor.white.renderableColor,
                                backgroundColor: UIColor.red.renderableColor)
        
        let textEntity2 = TextEntity(contents: "Good bye 👻 !!!",
                                    order: 3,
                                    scale: CGPoint(x: 1, y: 0.93),
                                    translation: CGPoint(x: 0.5, y: 0),
                                    rotation: 0,
                                    fontSize: 14,
                                    color: UIColor.white.renderableColor,
                                    backgroundColor: UIColor.red.renderableColor)
        
        
        let backgroundEntity = SolidColorEntity(order: 0,
                                                scale: CGPoint(x: 1, y: 1),
                                                translation: .zero,
                                                rotation: .zero,
                                                color: UIColor.white.renderableColor)
        
        
        let basicMacro = SolidBackgroundMacro(backgroundLayer: backgroundEntity, canvasSize: .init(width: 1080, height: 1000))
        basicMacro.add(entity: image1)
        basicMacro.add(entity: image2)
        basicMacro.add(entity: textEntity)
        basicMacro.add(entity: textEntity2)
        
        return basicMacro
    }
    
    static var Macros: [SwpannableMacro] = {
        var macros = [SwpannableMacro]()
        
        if let macroUrl = Bundle.main.url(forResource: "MemeMacro", withExtension: "json") {
            if let jsonData = try? Data(contentsOf: macroUrl),
               let macro = try? JSONDecoder().decode(SolidBackgroundMacro.self, from: jsonData) {
                macros.append(macro)
            }
        }
        
        if let macroUrl = Bundle.main.url(forResource: "Meme 2", withExtension: "json") {
            if let jsonData = try? Data(contentsOf: macroUrl),
               let macro = try? JSONDecoder().decode(SolidBackgroundMacro.self, from: jsonData) {
                macros.append(macro)
            }
        }
        
        if let macroUrl = Bundle.main.url(forResource: "meme 3", withExtension: "json") {
            if let jsonData = try? Data(contentsOf: macroUrl),
               let macro = try? JSONDecoder().decode(ImageBackgroundMacro.self, from: jsonData) {
                macros.append(macro)
            }
        }
        
        
        return macros
    }()
}
