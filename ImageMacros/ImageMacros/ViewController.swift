//
//  ViewController.swift
//  ImageMacros
//
//  Created by Shreyash Shah on 06/11/22.
//

import UIKit
import SnapKit
import CoreImage
import MetalKit


class ViewController: UIViewController {
    
    var preview: MTKView = {
        let view = MTKView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.preferredFramesPerSecond = 60
        view.framebufferOnly = false        
        
        return view
    }()
    
    var exportButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 3
        button.setTitle("Export ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    // TODO: Temporary workaround, should be replaced with better UI/UX
    var switchMacro: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 3
        button.setTitle("Switch Macro ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()

    // TODO: Temporary hardcoding
    var macroIndex: Int = 0
    
    var compistedImage: CIImage?
    
    var macroSpawner: MacroSpawner?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
        
        let basicMacro = HardCodings.BasicTestMacro
        macroSpawner = MacroSpawner(macro: basicMacro)
        
        preview.snp.removeConstraints()
        preview.snp.updateConstraints { make in
            make.width.equalTo(basicMacro.canvasSize.width / UIScreen.main.scale)
            make.height.equalTo(basicMacro.canvasSize.height / UIScreen.main.scale)
            make.center.equalToSuperview()
        }
        
        
        // MARK: Demoing macros to JSON serialisation, can be used to save the user session state
        do {
            let data = try JSONEncoder().encode(basicMacro)
            debugPrint(String(data: data, encoding: .utf8)! as AnyObject)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func setupSubViews() {
        // MARK: preview
        preview.device = Renderer.shared.device
        preview.delegate = self
        view.addSubview(preview)
        preview.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        
        // MARK: Export image button
        view.addSubview(exportButton)
        exportButton.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        exportButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        
        
        // MARK: Macros collection view
        view.addSubview(switchMacro)
        switchMacro.addTarget(self, action: #selector(switchMacroTapped), for: .touchUpInside)
        switchMacro.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(110)
        }

    }
    
    @objc func exportButtonTapped() {
        guard let macroSpawner = macroSpawner else {
            return
        }
        
        let spawnedImage = macroSpawner.spawnAll()
        
        let imageRegion = CGRect(origin: .zero, size: macroSpawner.macro.canvasSize)
        
        guard let exportedImage = Renderer.shared.ciContext.createCGImage(spawnedImage, from: imageRegion) else {
            showToast(message: "❌ Couldn't export image")
            return
        }
        
        let image = UIImage(cgImage: exportedImage)
       
        showToast(message: "✅ Image rendered")

        // MARK: Open share-sheet to share the exported image
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // TODO: Temporary workaround, should be replaced with better UI/UX
    @objc func switchMacroTapped() {
        macroIndex += 1;
        if macroIndex >= HardCodings.Macros.count {
            macroIndex = 0
        }
        
        let newMacro = HardCodings.Macros[macroIndex]
        
        // MARK: Loads macros from JSON
        macroSpawner?.set(macro: newMacro)
        
        preview.snp.removeConstraints()
        preview.snp.makeConstraints { make in
            make.width.equalTo(newMacro.canvasSize.width / UIScreen.main.scale)
            make.height.equalTo(newMacro.canvasSize.height / UIScreen.main.scale)
            make.center.equalToSuperview()
        }
    }
}


extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // TODO: Perform resize tasks if any
    }
    
    func draw(in view: MTKView) {
        guard let macroSpawner = macroSpawner else {
            return
        }
        
        guard let currentDrawable = preview.currentDrawable else {
            debugPrint("Unable to get currentDrawable")
            return
        }
        
        let spawnedImage = macroSpawner.spawnAll()

        Renderer.shared.render(spawnedImage, into: currentDrawable)
    }
}


