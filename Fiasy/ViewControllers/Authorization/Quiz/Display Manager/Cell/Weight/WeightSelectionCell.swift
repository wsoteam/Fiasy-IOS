//
//  WeightSelectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class WeightSelectionCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var secondRulerView: RKMultiUnitRuler!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var growthLabel: UILabel!
    @IBOutlet weak var ruler: RKMultiUnitRuler?
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    private var segments = Array<RKSegmentUnit>()
    private var secondSegments = Array<RKSegmentUnit>()
    private var rangeStart = Measurement(value: 50.0, unit: UnitMass.kilograms)
    private var rangeLength = Measurement(value: Double(70), unit: UnitMass.kilograms)
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите ваш вес")
        delegate.changeStateBackButton(hidden: false)
        delegate.changeStateNextButton(state: true)
        delegate.changePageControl(index: 2)
    }
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRulerView()
    }
    
    // MARK: - Private -
    private func setupRulerView() {
        ruler?.direction = .horizontal
        ruler?.tintColor = #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        secondSegments = createSecondSegments()
        segments = self.createSegments()
        ruler?.delegate = self
        ruler?.dataSource = self
        
        let initialValue = (self.rangeForUnit(UnitMass.kilograms).location + self.rangeForUnit(UnitMass.kilograms).length) / 2
        ruler?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitMass.kilograms)
        ruler?.transform = CGAffineTransform(scaleX: 1, y: -1)
        ruler?.backgroundColor = .clear
        
        secondRulerView?.direction = .horizontal
        secondRulerView?.tintColor = #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        
        secondRulerView?.delegate = self
        secondRulerView?.dataSource = self
        
        secondRulerView?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitMass.kilograms)
        secondRulerView?.backgroundColor = .clear
        
        ruler?.completionHandler = { [weak self] scroll in
            self?.secondRulerView.updateScrollContentInset(scroll)
        }
    }
}

extension WeightSelectionCell: RKMultiUnitRulerDataSource, RKMultiUnitRulerDelegate {
    
    func unitForSegmentAtIndex(index: Int, viewTag: Int) -> RKSegmentUnit {
        return viewTag == 1 ? segments[index] : secondSegments[index]
    }
    
    func rangeForUnit(_ unit: Dimension) -> RKRange<Float> {
        let locationConverted = rangeStart.converted(to: unit as! UnitMass)
        let lengthConverted = rangeLength.converted(to: unit as! UnitMass)
        return RKRange<Float>(location: ceilf(Float(locationConverted.value)),
                              length: ceilf(Float(lengthConverted.value)))
    }
    
    var numberOfSegments: Int {
        get { return secondSegments.count }
        set {}
    }
    
    func styleForUnit(_ unit: Dimension) -> RKSegmentUnitControlStyle {
        let style: RKSegmentUnitControlStyle = RKSegmentUnitControlStyle()
        style.scrollViewBackgroundColor = .clear
        style.textFieldBackgroundColor = .clear
        style.textFieldTextColor = .clear
        return style
    }
    
    func valueChanged(measurement: NSMeasurement) {
        UserInfo.sharedInstance.registrationFlow.weight = measurement.doubleValue.displayOnly(count: 1)
        growthLabel.text = "\(measurement.doubleValue.displayOnly(count: 1)) кг".replacingOccurrences(of: ".0", with: "")
    }
    
    private func createSegments() -> Array<RKSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        let kgSegment = RKSegmentUnit(name: "", unit: UnitMass.kilograms, formatter: formatter)
        
        kgSegment.name = ""
        kgSegment.unit = UnitMass.kilograms
        let kgMarkerTypeMax = RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 50.0), scale: 0.1, unit: "кг")
        kgMarkerTypeMax.labelVisible = false
        kgSegment.markerTypes = [
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.1, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.2, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.3, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.4, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 20.0), scale: 0.5, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.6, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.7, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.8, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 10.0), scale: 0.9, unit: "кг"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 2.0, height: 40.0), scale: 1.0, unit: "кг")]
        
        kgSegment.markerTypes.last?.labelVisible = false
        return [kgSegment]
    }
    
    private func createSecondSegments() -> Array<RKSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        let kgSegment = RKSegmentUnit(name: "", unit: UnitMass.kilograms, formatter: formatter)
        
        kgSegment.name = ""
        kgSegment.unit = UnitMass.kilograms
        let kgMarkerTypeMax = RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 50.0), scale: 0.1, unit: "кг")
        kgMarkerTypeMax.labelVisible = true
        kgMarkerTypeMax.unit = "кг"
        kgSegment.markerTypes = [
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 2.0, height: 0.0), scale: 1.0, unit: "кг")]
        
        kgSegment.markerTypes.last?.labelVisible = true
        return [kgSegment]
    }
}


