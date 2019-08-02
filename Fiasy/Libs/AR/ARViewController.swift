//
//  ARViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import CoreML
import AMDots
import Vision
import AVFoundation
import Firebase
import FirebaseStorage
import Reachability

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
    
    //MARK: - Download Outles -
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dotView: AMDots!
    @IBOutlet weak var dotContainerVIew: UIView!
    
    //MARK: - Properties -
    private var task: StorageDownloadTask?
    private let handlerModel = MLModelHandler()
    private var finishScan: Bool = false
    private var arModel = UserInfo.sharedInstance.productModel
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
        
        checkIfFileAvailable()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        
        dotView.colors = [#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1),#colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)]
        dotView.backgroundColor = UIColor.white
        dotView.animationType = .scale
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
        task?.cancel()
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
    
    func detectScene(image: CIImage) {
        guard let loadModel = self.arModel, !self.finishScan else { return }
        guard let model = try? VNCoreMLModel(for: loadModel) else {
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
    
    private func checkIfFileAvailable() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        if let pathComponent = NSURL(fileURLWithPath: path).appendingPathComponent("Food101.mlmodel") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                guard let model = self.arModel else {
                    titleLabel.text = "Подождите немного..."
                    descriptionLabel.text = "Идет настройка базы продуктов"
                    dotContainerVIew.isHidden = false
                    progressLabel.isHidden = true
                    loadButton.isHidden = true
                    dotView.start()
                    DispatchQueue.global(qos: .background).async {
                        let compiledUrl = self.handlerModel.compileModel(path: pathComponent)
                        if let url = self.handlerModel.compileModel(path: pathComponent) {
                            DispatchQueue.main.async {
                                self.arModel = try? MLModel(contentsOf: url)
                                UserInfo.sharedInstance.productModel = try? MLModel(contentsOf: url)
                                if let _ = self.arModel {
                                    self.backgroundView.isHidden = true
                                }
                            }
                        }
                    }
                    return
                }
                backgroundView.isHidden = true
                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
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
    
    @IBAction func loadClicked(_ sender: UIButton) {
        
        if checkWiFi() {
            self.loadClicked()
        } else {
            if let viewController = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "AlertPopUpViewController") as? AlertPopUpViewController {
                
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.modalTransitionStyle = .crossDissolve
                
                viewController.completion = { [weak self] in
                    self?.loadClicked()
                }
                present(viewController, animated: true)
            }
        }
    }
    
    private func loadClicked() {
        loadButton.isHidden = true
        downloadImageView.image = #imageLiteral(resourceName: "load_icon")
        titleLabel.text = "Подождите немного..."
        descriptionLabel.text = "Идет загрузка"
        dotContainerVIew.isHidden = false
        progressLabel.isHidden = false
        dotView.start()
        
        let store = Storage.storage()
        let referenceForURL = store.reference(forURL: "gs://diet-for-test.appspot.com/ARModel/Food101.mlmodel")
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("Food101.mlmodel")
        task = referenceForURL.write(toFile: localURL)
        
        let downloadTask = task?.observe(.progress) { snapshot in
            if snapshot.progress!.completedUnitCount <= 0 { return }
            let percentComplete = 100 * Int(snapshot.progress!.completedUnitCount)
                / Int(snapshot.progress!.totalUnitCount)
            self.progressLabel.text = "\(percentComplete) %"
        }
        
        let success = task?.observe(.success) { snapshot in
            self.checkIfFileAvailable()
        }
    }
    
    private func checkWiFi() -> Bool {
        
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN):
            print("Connected via WWAN")
            return false
        case .Online(.WiFi):
            print("Connected via WiFi")
            return true
        }
    }
}
