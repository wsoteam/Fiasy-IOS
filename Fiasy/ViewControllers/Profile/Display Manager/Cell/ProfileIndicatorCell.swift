//
//  ProfileIndicatorCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Charts

enum ChartsState {
    case week
    case mounth
    case year
}

class ProfileIndicatorCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet var selectedButtons: [UIButton]!
    @IBOutlet var chartView: BarChartView!
    
    // MARK: - Properties -
    private var delegate: ProfileDelegate?
    private var chartsState: ChartsState = .week
    
    private var selectedData = Date()

    private var currentYear = Calendar.current.component(.year, from: Date())
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var currentDay = Calendar.current.component(.day, from: Date())
    
    private lazy var mounthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL"
        return formatter
    }()
    private lazy var weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        formatter.dateFormat = "dd.MM"
        return formatter
    }()
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        formatter.dateFormat = "dd"
        return formatter
    }()

    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        changeChartsState(state: chartsState)
//        setupCharts(by: chartsState)
//        leftArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    // MARK: - Interface -
    func fillCell() {
        //self.delegate = delegate
        
        changeChartsState(state: chartsState)
        setupCharts(by: chartsState)
        leftArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    // MARK: - Private -
    private func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
    }
    
    private func setupChart(firstValue: [String], secondValue: [Double]) {
        chartView.drawBarShadowEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.maxVisibleCount = firstValue.count
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.3803474307, green: 0.3804178834, blue: 0.38034302, alpha: 1)
        xAxis.labelFont = UIFont.sfProTextMedium(size: 10)
        xAxis.labelCount = firstValue.count
        
        switch chartsState {
        case .week:
            xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        case .mounth:
            xAxis.valueFormatter = MounthAxisValueFormatter(chart: chartView, array: firstValue)
        default:
            xAxis.valueFormatter = YearAxisValueFormatter(chart: chartView)
        }

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelFont = UIFont.sfProTextMedium(size: 12)
        leftAxis.labelCount = firstValue.count
        leftAxis.labelTextColor = #colorLiteral(red: 0.3803474307, green: 0.3804178834, blue: 0.38034302, alpha: 1)
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        leftAxis.labelPosition = .outsideChart

        leftAxis.axisMinimum = 0
        leftAxis.drawZeroLineEnabled = true
        leftAxis.drawLimitLinesBehindDataEnabled = true

        let marker = XYMarkerView(color: #colorLiteral(red: 0.9842075706, green: 0.9843025804, blue: 0.9882965684, alpha: 1),
                                 font: UIFont.sfProTextBold(size: 13),
                            textColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1),
                               insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        setChart(dataPoints: firstValue, values: secondValue)
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.highlightAlpha = 0.1

        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.4
        chartDataSet.colors = [#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]
        
        chartView.data = chartData
        chartData.notifyDataChanged()
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        guard let profile = UserInfo.sharedInstance.currentUser else { return }
        let ll = ChartLimitLine(limit: Double(profile.maxKcal ?? 0), label: "")
        ll.lineColor = #colorLiteral(red: 0.6821895838, green: 0.7011895776, blue: 0.751206398, alpha: 1)
        ll.lineWidth = 3
        chartView.leftAxis.addLimitLine(ll)
        chartView.notifyDataSetChanged()
    }

    private func setupCharts(by state: ChartsState) {
        chartView.clearValues()
        chartView.notifyDataSetChanged()
        chartView.data = nil
        
        self.setup(barLineChartView: chartView)
        
        var stringArray: [String] = []
        var valueArray: [Double] = []
        var mounthArray = [[Int]]()
        var weakArray: [Int] = []
        
        switch state {
        case .mounth:
            var date: Date = Calendar.current.startOfMonth(selectedData)
            for _ in 0...numberOfWeeksInMonth(selectedData) {
                if stringArray.isEmpty {
                    var array: [Int] = []
                    for item in date.getWeekDates() {
                        if Calendar.current.component(.day, from: item) > 8 { continue }
                        if array.isEmpty {
                            array.append(1)
                        } else {
                            array.append(Calendar.current.component(.day, from: item))
                        }
                    }
                    mounthArray.append(array)
                    stringArray.append("\(dayFormatter.string(from: date)) - \(dayFormatter.string(from: date.endOfWeek!))")
                } else {
                    if stringArray.count >= 5 { break }
                    date = date.getNextWeek()!
                    var array: [Int] = []
                    for item in date.getWeekDates() {
                        if (array.last ?? 0) > Calendar.current.component(.day, from: item) { break }
                        array.append(Calendar.current.component(.day, from: item))
                    }
                    mounthArray.append(array)
                    stringArray.append("\(dayFormatter.string(from: date.startOfWeek)) - \(dayFormatter.string(from: date.endOfWeek!))")
                }
        }
        case .week:
            for item in selectedData.startOfWeek.getWeekDates() {
                weakArray.append(Calendar.current.component(.day, from: item))
            }
            stringArray = ["", "", "", "", "", "", ""]
        default:
            stringArray = ["", "", "", "", "", "", "", "", "", "", "", ""]
        }
        if UserInfo.sharedInstance.allMealtime.isEmpty {
            for _ in stringArray {
                valueArray.append(Double(0.0))
            }
        } else {
            valueArray = ChartsFlow.fetchValues(chartsState: chartsState, array: stringArray, date: selectedData, mounthArray, weakArray)
        }
        var count: Double = 0.0
        for item in valueArray {
            count = count + item
        }
        if count >= (Double(UserInfo.sharedInstance.currentUser?.maxKcal ?? 0)) {
            chartView.leftAxis.resetCustomAxisMax()
        } else {
            chartView.leftAxis.axisMaximum = (Double(UserInfo.sharedInstance.currentUser?.maxKcal ?? 0)) + 500
        }
        
        self.setupChart(firstValue: stringArray, secondValue: valueArray)
    }
    
    private func clearBackgroundButtons() {
        for item in selectedButtons {
            item.backgroundColor = .clear
            item.setTitleColor(#colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), for: .normal)
        }
    }

    private func numberOfWeeksInMonth(_ date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        calendar.firstWeekday = 1
        let weekRange = calendar.range(of: .weekOfMonth,
                                      in: .month,
                                     for: date)
        return weekRange!.count
    }

    
    private func changeChartsState(state: ChartsState) {
        rightArrow.isEnabled = true
        yearLabel.isHidden = false
        switch state {
        case .week:
            yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
            centerLabel.text = "\(weekFormatter.string(from: selectedData.startOfWeek)) - \(weekFormatter.string(from: selectedData.endOfWeek!))"
            checkRightArrowButtonByWeek()
        case .mounth:
            yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
            centerLabel.text = "\(mounthFormatter.string(from: selectedData))".capitalizeFirst
            
            if let second = selectedData.getNextMonth(), Calendar.current.component(.year, from: second) < Calendar.current.component(.year, from: Date()) {
                rightArrow.isEnabled = true
            } else if let second = selectedData.getNextMonth(), Calendar.current.component(.year, from: second) == Calendar.current.component(.year, from: Date()) && Calendar.current.component(.month, from: second) <= Calendar.current.component(.month, from: Date()) {
                rightArrow.isEnabled = true
            } else {
                rightArrow.isEnabled = false
            }
        default:
            yearLabel.isHidden = true
            centerLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
            if let next = selectedData.getNextYear(), Calendar.current.component(.year, from: next) > currentYear {
                rightArrow.isEnabled = false
            }
        }
        setupCharts(by: chartsState)
    }
    
    private func checkRightArrowButtonByWeek() {
        setupCharts(by: chartsState)
        if Calendar.current.component(.year, from: selectedData) < Calendar.current.component(.year, from: Date()) {
            rightArrow.isEnabled = true
        } else if Calendar.current.component(.year, from: selectedData) == Calendar.current.component(.year, from: Date()) && Calendar.current.component(.month, from: selectedData) < Calendar.current.component(.month, from: Date()) {
            rightArrow.isEnabled = true
        } else if Calendar.current.component(.year, from: selectedData) == Calendar.current.component(.year, from: Date()) && Calendar.current.component(.month, from: selectedData) == Calendar.current.component(.month, from: Date()) {
            if let next = selectedData.getNextWeek(), Calendar.current.component(.month, from: next) <= Calendar.current.component(.month, from: Date()) {
                rightArrow.isEnabled = true
            } else {
                rightArrow.isEnabled = false
            }
        } else {
            rightArrow.isEnabled = false
        }
    }

    // MARK: - Actions -
    @IBAction func leftArrowClicked(_ sender: Any) {
        switch chartsState {
        case .year:
            if let previous = selectedData.getPreviousYear() {
                selectedData = previous
                centerLabel.text = "\(Calendar.current.component(.year, from: previous))"
            }
            if Calendar.current.component(.year, from: selectedData) >= Calendar.current.component(.year, from: Date()) {
                rightArrow.isEnabled = false
            } else {
                rightArrow.isEnabled = true
            }
        case .mounth:
            if let previous = selectedData.getPreviousMonth() {
                selectedData = previous
                yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
                centerLabel.text = "\(mounthFormatter.string(from: selectedData))".capitalizeFirst
            }
            
            if Calendar.current.component(.year, from: selectedData) < Calendar.current.component(.year, from: Date()) {
                rightArrow.isEnabled = true
            } else if Calendar.current.component(.year, from: selectedData) == Calendar.current.component(.year, from: Date()) && Calendar.current.component(.month, from: selectedData) <= Calendar.current.component(.month, from: Date()) {
                rightArrow.isEnabled = true
            } else {
                rightArrow.isEnabled = false
            }
        case .week:
            if let previous = selectedData.getPreviousWeek() {
                selectedData = previous
                yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
                centerLabel.text = "\(weekFormatter.string(from: selectedData.startOfWeek)) - \(weekFormatter.string(from: selectedData.endOfWeek!))"
            }
            checkRightArrowButtonByWeek()
        }
        setupCharts(by: chartsState)
    }
    
    @IBAction func rightArrowClicked(_ sender: Any) {
        switch chartsState {
        case .year:
            if let next = selectedData.getNextYear() {
                selectedData = next
                centerLabel.text = "\(Calendar.current.component(.year, from: next))"
            }
            if Calendar.current.component(.year, from: selectedData) >= Calendar.current.component(.year, from: Date()) {
                rightArrow.isEnabled = false
            } else {
                rightArrow.isEnabled = true
            }
        case .mounth:
            if let next = selectedData.getNextMonth() {
                selectedData = next
                yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
                centerLabel.text = "\(mounthFormatter.string(from: next))".capitalizeFirst

                if let second = next.getNextMonth(), Calendar.current.component(.year, from: second) < Calendar.current.component(.year, from: Date()) {
                    rightArrow.isEnabled = true
                } else if let second = next.getNextMonth(), Calendar.current.component(.year, from: second) == Calendar.current.component(.year, from: Date()) && Calendar.current.component(.month, from: second) <= Calendar.current.component(.month, from: Date()) {
                    rightArrow.isEnabled = true
                } else {
                    rightArrow.isEnabled = false
                }
            }
        case .week:
            if let next = selectedData.getNextWeek() {
                selectedData = next
                yearLabel.text = "\(Calendar.current.component(.year, from: selectedData))"
                centerLabel.text = "\(weekFormatter.string(from: selectedData.startOfWeek)) - \(weekFormatter.string(from: selectedData.endOfWeek!))"
            }
            checkRightArrowButtonByWeek()
        }
        setupCharts(by: chartsState)
    }
    
    @IBAction func buttonsClicked(_ sender: UIButton) {
        clearBackgroundButtons()
        selectedButtons[sender.tag].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        selectedButtons[sender.tag].backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        switch sender.tag {
        case 0:
            chartsState = .week
        case 1:
            chartsState = .mounth
        default:
            chartsState = .year
        }
        changeChartsState(state: chartsState)
    }
}
