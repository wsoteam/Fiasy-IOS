//
//  BasketAlertRemoveView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import UICircularProgressRing

class BasketAlertRemoveView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var progressView: UICircularTimerRing!
    @IBOutlet weak var timerLabel: CountdownLabel!
    
    // MARK: - Outlet -
    private var indexPath: IndexPath?
    private var delegate: BasketDelegate?
    private var startTimer: Bool = true
    private var isFinished: Bool = false
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancelButton.setTitle(LS(key: .CANCEL).capitalizeFirst, for: .normal)
        removeButton.setTitle(" \(LS(key: .REMOVE_PRODUCT))", for: .normal)
    }
    
    // MARK: - Interface -
    func fillView(delegate: BasketDelegate, index: IndexPath) {
        self.delegate = delegate
        self.indexPath = index
        
        timerLabel.setCountDownTime(minutes: 3)
        timerLabel.timeFormat = "ss"
        timerLabel.animationType = .Evaporate
        timerLabel.start()
        
        isFinished = false
        startTimer = true
        progressView.startTimer(to: 3) { state in
            switch state {
            case .finished:
                guard !self.isFinished else { return }
                guard let index = self.indexPath, self.startTimer else { return }
                self.isFinished = true
                self.delegate?.removeProduct(indexPath: index)
            default:
                break
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func cancelClicked(_ sender: Any) {
        guard !isFinished else { return }
        self.isFinished = true
        startTimer = false
        progressView.pauseTimer()
        timerLabel.cancel()
        guard let index = self.indexPath else { return }
        delegate?.cancelRemoveProduct(indexPath: index)
    }
}
