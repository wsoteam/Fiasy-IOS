//
//  WeightSelectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class WeightSelectionCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var mifinLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var growthLabel: UILabel!
    @IBOutlet weak var rulerContainerView: UIView!
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: LS(key: .SELECT_YOUR_WEIGHT))
        delegate.changeStateBackButton(hidden: false)
        delegate.changeStateNextButton(state: true)
        delegate.changePageControl(index: 2)
    }
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mifinLabel.text = LS(key: .MIFFLIN_FORMULA)
        growthLabel.text = "\(60) \(LS(key: .WEIGHT_UNIT))"
        
        setupRulerView()
        Amplitude.instance()?.logEvent("question_next", withEventProperties: ["question" : "weight"]) // +
    }
    
    // MARK: - Private -
    private func setupRulerView() {
        let ruler = DTRuler(scale: .float(59.8), minScale: .float(30), maxScale: .float(200), width: rulerContainerView.bounds.width)
        ruler.delegate = self
        rulerContainerView.addSubview(ruler)
        
        ruler.translatesAutoresizingMaskIntoConstraints = false
        let bottom = NSLayoutConstraint(item: ruler, attribute: .bottom, relatedBy: .equal, toItem: rulerContainerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: ruler, attribute: .leading, relatedBy: .equal, toItem: rulerContainerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: ruler, attribute: .trailing, relatedBy: .equal, toItem: rulerContainerView, attribute: .trailing, multiplier: 1, constant: 0)
        rulerContainerView.addConstraints([bottom, leading, trailing])
    }
}

extension WeightSelectionCell: DTRulerDelegate {
    
    func didChange(on ruler: DTRuler, withScale scale: DTRuler.Scale) {
        if let double = Double(scale.minorTextRepresentation()) {
            UserInfo.sharedInstance.registrationFlow.weight = double
        }
        growthLabel.text = "\(scale.minorTextRepresentation()) \(LS(key: .WEIGHT_UNIT))".replacingOccurrences(of: ".0", with: "")
    }
}
