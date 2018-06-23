//
//  FirstViewController.swift
//  lucid-crm-reportz-viewer
//
//  Created by Darshan Gulur Srinivasa on 6/23/18.
//  Copyright © 2018 Lucid Infosystems LLC. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class FirstViewController: UIViewController {

    // MARK: - Private properties
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 1
        $0.font = UIFont(name: "Helvetica-Bold", size: 35)
        $0.textColor = .gray
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private let ITEM_COUNT = 12
    private let padding: CGFloat = 100
    private var chartView = CombinedChartView()
    private let months = ["Jan", "Feb", "Mar",
                          "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep",
                          "Oct", "Nov", "Dec"]

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()

        titleLabel.text = "Sales per month and projections for FY 2019-20"
    }

    // MARK: - Private functions
    private func addSubViews() {
        addCombinedChartView()
        view.addSubview(titleLabel)

        titleLabel.edgesToSuperview(excluding: .top,
                                    insets: TinyEdgeInsets(top: 0,
                                                           left: padding,
                                                           bottom: padding,
                                                           right: -padding))
        titleLabel.topToBottom(of: chartView, offset: padding / 4)
    }
    private func addCombinedChartView() {
        view.addSubview(chartView)

        chartView.edgesToSuperview(excluding: .bottom,
                                   insets: TinyEdgeInsets(top: padding,
                                                          left: padding,
                                                          bottom: padding * 2,
                                                          right: -padding))

//        chartView.delegate = self

        chartView.chartDescription?.enabled = false

        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false

        chartView.drawOrder = [DrawOrder.bar.rawValue,
                               DrawOrder.bubble.rawValue,
                               DrawOrder.candle.rawValue,
                               DrawOrder.line.rawValue,
                               DrawOrder.scatter.rawValue]

        let l = chartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        //        chartView.legend = l

        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = 0

        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.valueFormatter = self

        self.setChartData()
    }

    private func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()

        chartView.xAxis.axisMaximum = data.xMax + 0.25

        chartView.data = data
    }

    private func generateLineData() -> LineChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
        }

        let set = LineChartDataSet(values: entries, label: "Revenue by month")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)

        set.axisDependency = .left

        return LineChartData(dataSet: set)
    }

    private func generateBarData() -> BarChartData {
        let entries1 = (0..<ITEM_COUNT).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, y: Double(arc4random_uniform(25) + 25))
        }
        let entries2 = (0..<ITEM_COUNT).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
        }

        let set1 = BarChartDataSet(values: entries1, label: "Projected monthly sales")
        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left

        let set2 = BarChartDataSet(values: entries2, label: "")
        set2.stackLabels = ["Current month profit", "expenses"]
        set2.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 10)
        set2.axisDependency = .left

        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"

        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth

        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)

        return data
    }

    private func generateScatterData() -> ScatterChartData {
        let entries = stride(from: 0.0, to: Double(ITEM_COUNT), by: 0.5).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: i+0.25, y: Double(arc4random_uniform(10) + 55))
        }

        let set = ScatterChartDataSet(values: entries, label: "Scatter plot representation")
        set.colors = ChartColorTemplates.material()
        set.scatterShapeSize = 4.5
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: 10)

        return ScatterChartData(dataSet: set)
    }

    private func generateCandleData() -> CandleChartData {
        let entries = stride(from: 0, to: ITEM_COUNT, by: 2).map { (i) -> CandleChartDataEntry in
            return CandleChartDataEntry(x: Double(i+1), shadowH: 90, shadowL: 70, open: 85, close: 75)
        }

        let set = CandleChartDataSet(values: entries, label: "Profit range")
        set.setColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1))
        set.decreasingColor = UIColor(red: 142/255, green: 150/255, blue: 175/255, alpha: 1)
        set.shadowColor = .darkGray
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false

        return CandleChartData(dataSet: set)
    }

    private func generateBubbleData() -> BubbleChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> BubbleChartDataEntry in
            return BubbleChartDataEntry(x: Double(i) + 0.5,
                                        y: Double(arc4random_uniform(10) + 105),
                                        size: CGFloat(arc4random_uniform(50) + 105))
        }

        let set = BubbleChartDataSet(values: entries, label: "Projection for next year (all numbers in millions of Dollars)")
        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = true

        return BubbleChartData(dataSet: set)
    }
}

extension FirstViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
