//
//  BarcodeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import AVFoundation
import Amplitude_iOS

protocol BarcodeDelegate {
    func foundBarcode(code: String)
}

class BarcodeViewController: BarcodeScannerViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: BarcodeDelegate?
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeDelegate = self
    }
    
    // MARK: - Interface -
    func fillDelegate(delegate: BarcodeDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Action -
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func flashClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        toggleTorch(on: sender.isSelected)
    }
    
    // MARK: - Private -
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}

extension BarcodeViewController: BarcodeScannerCodeDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        Amplitude.instance()?.logEvent("scan_barcode", withEventProperties: ["barcode_id" : code])
        
        if let delegate = self.delegate {
            delegate.foundBarcode(code: code)
            dismiss(animated: true)
        } else {
            descriptionLabel.alpha = 1.0
            UIView.animate(withDuration: 5, animations: {
                self.descriptionLabel.alpha = 0.0
            })
        }
    }
}
