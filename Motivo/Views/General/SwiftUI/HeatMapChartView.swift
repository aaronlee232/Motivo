//
//  HeatMapChartView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/25/25.
//
// https://www.artemnovichkov.com/blog/github-contribution-graph-swift-charts

import SwiftUI
import Charts

struct HeatMapChartView: View {
    let pastMonths = 3
    
    @State var contributions: [Contribution]
    let endDate = Date()
    var startDate: Date {
        let date = Calendar.current.date(byAdding: .month, value: -pastMonths, to: endDate)!
        let startOfWeek = DateUtils.shared.calendar.dateInterval(of: .weekOfYear, for: date)!.start
        return startOfWeek
    }
    
    // pass in some kind of contributions: [Contribution]
    init() {
        let sparseContributions = Contribution.generate(forPastMonths: pastMonths)
        self.contributions = Contribution.fillGenerate(sparseContributions: sparseContributions, forPastMonths: pastMonths)
    }
    
    var body: some View {
        Chart(contributions) { contribution in
            RectangleMark(
                xStart: .value("Start week", contribution.date, unit: .weekOfYear),
                xEnd: .value("End week", contribution.date, unit: .weekOfYear),
                yStart: .value("Start weekday", weekday(for: contribution.date)),
                yEnd: .value("End weekday", weekday(for: contribution.date) + 1)
            )
            
            // Fill frame (to have some spacing around mark) and apply color
            .clipShape(RoundedRectangle(cornerRadius: 4).inset(by: 2))
            .foregroundStyle(by: .value("Count", contribution.count))
        }
        
        // Change marks to be squares
        .chartPlotStyle { content in
            content
              .aspectRatio(aspectRatio, contentMode: .fit)
        }
        
        // Add Colors
        .chartForegroundStyleScale(range: Gradient(colors: colors))
        
        // Customizing the axes -
        // For the x-axis we'll show only month labels at the top of the chart and change the color:
        .chartXAxis {
            AxisMarks(position: .top, values: .stride(by: .month)) {
                AxisValueLabel(format: .dateTime.month())
                    .foregroundStyle(Color(.label))
            }
        }
        
        // For the y-axis we'll display day of the week
        .chartYAxis {
            AxisMarks(position: .leading, values: [1, 3, 5]) { value in
                if let value = value.as(Int.self) {
                    AxisValueLabel {
                        // Symbols from Calendar.current starting with Sunday
                        Text(shortWeekdaySymbols(for: value))
                    }
                    .foregroundStyle(Color(.label))
                }
            }
        }
        
        // Show Sunday at the top and remove extra gap between 0 and 1 on x-axis
        .chartYScale(domain: .automatic(includesZero: false, reversed: true))
        
        // Color coded legend
        .chartLegend {
            HStack(spacing: 4) {
                Text("Less")
                ForEach(legendColors, id: \.self) { color in
                    color
                        .frame(width: 10, height: 10)
                        .cornerRadius(2)
                }
                Text("More")
            }
            .padding(4)
            .foregroundStyle(Color(.label))
            .font(.caption2)
        }
    }
    
    private func weekday(for date: Date) -> Int {
        return Calendar.current.component(.weekday, from: date)
    }
    
    private var aspectRatio: Double {
        if contributions.isEmpty {
            return 1
        }
        let firstDate = contributions.first!.date
        let lastDate = contributions.last!.date
        let firstWeek = Calendar.current.component(.weekOfYear, from: firstDate)
        let lastWeek = Calendar.current.component(.weekOfYear, from: lastDate)
        return Double(lastWeek - firstWeek + 1) / 7
    }
    
    private var colors: [Color] {
        (0...10).map { index in
            if index == 0 {
                return Color(.systemGray5)
            }
            return Color(colorMainPrimary).opacity(Double(index) / 10)
        }
    }
    
    private func shortWeekdaySymbols(for day: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        let shortWeekdays = formatter.shortWeekdaySymbols  // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return shortWeekdays![day]
    }
    
    private var legendColors: [Color] {
        Array(stride(from: 0, to: colors.count, by: 2).map { colors[$0] })
    }
}
