//
//  GrowthSelectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class GrowthSelectionCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var growthLabel: UILabel!
    @IBOutlet weak var ruler: RKMultiUnitRuler?
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    private var segments = Array<RKSegmentUnit>()
    private var rangeStart = Measurement(value: 50, unit: UnitLength.centimeters)
    private var rangeLength = Measurement(value: 258, unit: UnitLength.centimeters)
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите ваш рост")
        delegate.changeStateBackButton(hidden: false)
        delegate.changePageControl(index: 1)
    }

    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRulerView()
    }

    // MARK: - Private -
    private func setupRulerView() {
        ruler?.direction = .vertical
        ruler?.tintColor = #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        segments = self.createSegments()
        ruler?.delegate = self
        ruler?.dataSource = self
        
        let initialValue = (self.rangeForUnit(UnitLength.centimeters).location + self.rangeForUnit(UnitLength.centimeters).length) / 2
        ruler?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitLength.centimeters)
        arrowImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        ruler?.backgroundColor = .clear
    }
}

extension GrowthSelectionCell: RKMultiUnitRulerDataSource, RKMultiUnitRulerDelegate {
    
    func unitForSegmentAtIndex(index: Int, viewTag: Int) -> RKSegmentUnit {
        return segments[index]
    }

    func rangeForUnit(_ unit: Dimension) -> RKRange<Float> {
        let locationConverted = rangeStart.converted(to: unit as! UnitLength)
        let lengthConverted = rangeLength.converted(to: unit as! UnitLength)
        return RKRange<Float>(location: ceilf(Float(locationConverted.value)),
                              length: ceilf(Float(lengthConverted.value)))
    }
    
    var numberOfSegments: Int {
        get { return segments.count }
        set {}
    }
    
    func styleForUnit(_ unit: Dimension) -> RKSegmentUnitControlStyle {
        let style: RKSegmentUnitControlStyle = RKSegmentUnitControlStyle()
        style.scrollViewBackgroundColor = .clear
        let range = self.rangeForUnit(unit)
        if unit == UnitMass.pounds {
            
            style.textFieldBackgroundColor = UIColor.clear
            // color override location:location+40% red , location+60%:location.100% green
        } else {
            style.textFieldBackgroundColor = UIColor.red
        }
//        if (colorOverridesEnabled) {
//            style.colorOverrides = [
//                RKRange<Float>(location: range.location, length: 0.1 * (range.length)): UIColor.red,
//                RKRange<Float>(location: range.location + 0.4 * (range.length), length: 0.2 * (range.length)): UIColor.green]
//        }
        style.textFieldBackgroundColor = UIColor.clear
        style.textFieldTextColor = UIColor.white
        return style
    }
    
    func valueChanged(measurement: NSMeasurement) {
        growthLabel.text = "\(measurement.doubleValue) см".replacingOccurrences(of: ".0", with: "")
    }
    
    private func createSegments() -> Array<RKSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        let kgSegment = RKSegmentUnit(name: "", unit: UnitLength.centimeters, formatter: formatter)
        
        kgSegment.name = ""
        kgSegment.unit = UnitLength.centimeters
        let kgMarkerTypeMax = RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 50.0), scale: 10.0, unit: "см")
        kgMarkerTypeMax.labelVisible = true
        kgSegment.markerTypes = [
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 1.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 2.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 3.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 4.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 25.0), scale: 5.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 6.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 7.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 8.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 1.0, height: 11.0), scale: 9.0, unit: "см"),
            RKRangeMarkerType(color: #colorLiteral(red: 0.3764262497, green: 0.3764960766, blue: 0.3764218688, alpha: 1), size: CGSize(width: 2.0, height: 50.0), scale: 10.0, unit: "см")]
        kgSegment.markerTypes.last?.labelVisible = true
        return [kgSegment]
    }
}
