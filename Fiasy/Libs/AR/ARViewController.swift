//
//  ARViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class ARViewController: UIViewController, FrameExtractorDelegate {
    
    //MARK: - Outlets -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var defineButton: UIButton!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var iSee: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydrates: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    //MARK: - Properties -
    private var finishScan: Bool = false
    var frameExtractor: FrameExtractor!
    var settingImage = false
    
    var currentImage: CIImage? {
        didSet {
            if let image = currentImage{
                self.detectScene(image: image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    func captured(image: UIImage) {
        
        self.previewImage.image = image
        if let cgImage = image.cgImage, !settingImage {
            settingImage = true
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.currentImage = CIImage(cgImage: cgImage)
            }
        }
    }
    
    func addEmoji(id: String) -> String {
        switch id {
        case "pizza":
            return "🍕"
        case "hot dog":
            return "🌭"
        case "chicken wings":
            return "🍗"
        case "french fries":
            return "🍟"
        case "sushi":
            return "🍣"
        case "chocolate cake":
            return "🍫🍰"
        case "donut":
            return "🍩"
        case "spaghetti bolognese":
            return "🍝"
        case "caesar salad":
            return "🥗"
        case "macaroni and cheese":
            return "🧀"
        default:
            return ""
        }
    }
    
    func detectScene(image: CIImage) {
        guard !self.finishScan else { return }
        guard let model = try? VNCoreMLModel(for: Food101().model) else {
            fatalError()
        }
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let strongSelf = self else { return }
            guard let results = request.results as? [VNClassificationObservation],
                let _ = results.first else {
                    strongSelf.settingImage = false
                    return
            }

            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                guard !strongSelf.finishScan else { return }
                if let first = results.first, Int(first.confidence * 100) > 1 {
                    strongSelf.settingImage = false
                    strongSelf.defineButton.isEnabled = first.confidence > 0.8
                    strongSelf.defineButton.alpha = strongSelf.defineButton.isEnabled ? 1 : 0.5
                    if first.confidence > 0.8 {
                        SwiftGoogleTranslate.shared.translate(first.identifier, "rus", "en") { (text, error) in
                            if let t = text {
                                DispatchQueue.main.async { [weak self] in
                                    guard let strongSelf = self else { return }
                                    guard !strongSelf.finishScan else { return }
                                    strongSelf.iSee.text = t.lowercased() == "macarons" ? "Макаруны" : t.capitalizeFirst
                                }
                            }
                        }
                    } else {
                        strongSelf.iSee.text?.removeAll()
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    private func fillDishInfo(_ protein: String, _ fat: String, _ calories: String, _ carbohydrates: String) {
        self.proteinLabel.text = "\(protein) г"
        self.carbohydrates.text = "\(carbohydrates) г"
        self.caloriesLabel.text = "\(calories) г"
        self.fatLabel.text = "\(fat) г"
    }
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func defineClicked(_ sender: Any) {
        self.defineButton.isEnabled = false
        self.finishScan = true
        shareImageView.image = previewImage.image
        
        if let text = self.iSee.text?.lowercased() {
//            var items: [ListOfFoodItem] = []
//            for item in UserInfo.sharedInstance.allProducts where item.name?.lowercased().contains(text) ?? false {
//                items.append(item)
//            }
//            
//            if items.indices.contains(0) {
//                let sorted = items.sorted(by: {$0.name?.hasPrefix(text) == $1.name?.hasPrefix(text)})
//                iSee.text = sorted[0].name ?? iSee.text
//                fillDishInfo(sorted[0].protein ?? "0", sorted[0].fat ?? "0", sorted[0].calories ?? "0", sorted[0].carbohydrates ?? "0")
//            } else {
//                fillDishInfo("0", "0", "0", "0")
//            }
        }
        
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.containerView.alpha = 1
        }
    }
    
    @IBAction func shareClicked(_ sender: UIButton) {
        if let image = UIApplication.shared.screenShot {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(vc, animated: true)
        }
    }
}
