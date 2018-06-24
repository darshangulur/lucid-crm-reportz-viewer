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

    private let padding: CGFloat = 100
    private var chartView = HorizontalBarChartView()

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Performance Dashboard - Teams"
        view.backgroundColor = .white
        addSubViews()

        titleLabel.text = "Performances this month and future targets"
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
                                                          bottom: 0,
                                                          right: -padding))

        //        chartView.delegate = self

        chartView.chartDescription?.enabled = false

        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false

        // ChartYAxis *leftAxis = chartView.leftAxis;

        chartView.rightAxis.enabled = false

        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true

        chartView.maxVisibleCount = 60

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 10

        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l

        chartView.fitBars = true
        chartView.animate(yAxisDuration: 1)
        self.setDataCount(3, range: 50)
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0

        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val)
        }

        chartView.xAxis.valueFormatter = StringValueFormatter(
            chart: chartView,
            strings: ["Blue Resorts", "James Corp", "BMC Metro Works"]
        )

        let set1 = BarChartDataSet(values: yVals, label: "Performance of teams in Q1 (out of \(range)")
        set1.drawIconsEnabled = false

        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth

        chartView.data = data
    }
}
