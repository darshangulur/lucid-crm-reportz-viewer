//
//  SecondViewController.swift
//  lucid-crm-reportz-viewer
//
//  Created by Darshan Gulur Srinivasa on 6/23/18.
//  Copyright © 2018 Lucid Infosystems LLC. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class SecondViewController: UIViewController {

    // MARK: - Private properties
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 1
        $0.font = UIFont(name: "Helvetica-Bold", size: 35)
        $0.textColor = .gray
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private let datasets = ["Hamilton Hotels Group", "Blue State Insurance Corp.", "Hudson Metro Works"]
    private let padding: CGFloat = 100
    private var barChartView = HorizontalBarChartView()
    private var lineChartView = LineChartView()

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Performance Dashboard - Teams"
        view.backgroundColor = .white
        addSubViews()

        titleLabel.text = "Team Performances in Q1"
    }

    // MARK: - Private functions
    private func addSubViews() {
        addLineChartView()
        addBarChartView()
        view.addSubview(titleLabel)

        titleLabel.edgesToSuperview(excluding: .top,
                                    insets: TinyEdgeInsets(top: 0,
                                                           left: padding,
                                                           bottom: padding,
                                                           right: -padding))
        titleLabel.topToBottom(of: barChartView, offset: padding / 4)
    }
    
    private func addBarChartView() {
        view.addSubview(barChartView)

        barChartView.edgesToSuperview(excluding: [.top, .bottom],
                                      insets: TinyEdgeInsets(top: padding,
                                                             left: padding,
                                                             bottom: 0,
                                                             right: -padding))
        barChartView.topToBottom(of: lineChartView, offset: padding / 2)

        //        chartView.delegate = self

        barChartView.chartDescription?.enabled = false

        barChartView.dragEnabled = true
        barChartView.setScaleEnabled(true)
        barChartView.pinchZoomEnabled = false

        // ChartYAxis *leftAxis = chartView.leftAxis;

        barChartView.rightAxis.enabled = false

        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true

        barChartView.maxVisibleCount = 60

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 10

        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = barChartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l

        barChartView.fitBars = true
        barChartView.animate(yAxisDuration: 1)
        self.setBarChartDataCount(3, range: 50)
    }

    private func setBarChartDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0

        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val)
        }

        barChartView.xAxis.valueFormatter = StringValueFormatter(
            chart: barChartView,
            strings: datasets
        )

        let set1 = BarChartDataSet(values: yVals, label: "Team Performances in Q1 (out of \(range))")
        set1.drawIconsEnabled = false

        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth

        barChartView.data = data
    }

    private func addLineChartView() {
        view.addSubview(lineChartView)

        lineChartView.edgesToSuperview(excluding: .bottom,
                                   insets: TinyEdgeInsets(top: padding,
                                                          left: padding,
                                                          bottom: 0,
                                                          right: -padding))
        lineChartView.heightToSuperview(multiplier: 0.4)

//        chartView.delegate = self

        lineChartView.chartDescription?.enabled = false

        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false

        lineChartView.drawBordersEnabled = false
        lineChartView.setScaleEnabled(true)

        let l = lineChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        //        chartView.legend = l
        self.setLineChartDataCount(19, range: 75)
    }

    func setLineChartDataCount(_ count: Int, range: UInt32) {
        let colors = ChartColorTemplates.vordiplom()[0...2]

        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let dataSets = (0..<datasets.count).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(block)
            let set = LineChartDataSet(values: yVals, label: datasets[i])
            set.lineWidth = 2.5
            set.circleRadius = 4
            set.circleHoleRadius = 2
            let color = colors[i % colors.count]
            set.setColor(color)
            set.setCircleColor(color)

            return set
        }

        dataSets[0].lineDashLengths = [5, 5]
        dataSets[0].colors = ChartColorTemplates.vordiplom()
        dataSets[0].circleColors = ChartColorTemplates.vordiplom()

        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChartView.data = data
    }
}
