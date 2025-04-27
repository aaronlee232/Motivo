//
//  Contribution.swift
//  Motivo
//
//  Created by Aaron Lee on 4/25/25.
//

// https://www.artemnovichkov.com/blog/github-contribution-graph-swift-charts
// Still named contributions because I can't think of a better name that relates to habit progress

import Foundation

struct Completion: Identifiable {
    let date: Date
    let count: Float

    var id: Date {
        date
    }
}


extension Completion {
    // TODO: Remove this or replace with dummy data generation in firestore
    static func generate(forPastMonths pastMonths: Int, fromDate endDate: Date) -> [Completion] {
        var contributions: [Completion] = []
        let toDate = DateUtils.shared.calendar.startOfDay(for: endDate)
        let fromDate = Calendar.current.date(byAdding: .month, value: -pastMonths, to: toDate)!
        var paddedFromDate = fromDate
        while DateUtils.shared.calendar.component(.weekday, from: paddedFromDate) != 1 { // 1 is Sunday
            paddedFromDate = DateUtils.shared.calendar.date(byAdding: .day, value: -1, to: paddedFromDate)!
        }
        
        var currentDate = paddedFromDate
        while currentDate <= toDate {
            let contribution = Completion(date: currentDate, count: Float.random(in: 0...1))
            contributions.append(contribution)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return contributions
    }
    
    static func fillGenerate(
        sparseContributions: [Completion],
        fromDate actualStartDate: Date,
        toDate actualEndDate: Date // <-- "today"
    ) -> [Completion] {
        let calendar = DateUtils.shared.calendar

        // Pad start to the previous Sunday (if not already Sunday)
        var paddedFromDate = actualStartDate
        while calendar.component(.weekday, from: paddedFromDate) != 1 {
            paddedFromDate = calendar.date(byAdding: .day, value: -1, to: paddedFromDate)!
        }

        // Compute paddedToDate: the next Saturday after actualEndDate (today)
        var paddedToDate = actualEndDate
        let weekday = calendar.component(.weekday, from: paddedToDate)
        if weekday != 7 {
            let daysToAdd = 7 - weekday
            paddedToDate = calendar.date(byAdding: .day, value: daysToAdd, to: paddedToDate)!
        }

        let lookup = Dictionary(uniqueKeysWithValues: sparseContributions.map { (calendar.startOfDay(for: $0.date), $0) })

        var contributions: [Completion] = []
        var currentDate = paddedFromDate
        while currentDate <= paddedToDate {
            let dateKey = calendar.startOfDay(for: currentDate)
            if currentDate <= actualEndDate {
                // Real data up to today (or zero if not present)
                if let entry = lookup[dateKey] {
                    contributions.append(entry)
                } else {
                    contributions.append(Completion(date: dateKey, count: 0))
                }
            } else {
                // Only pad with zeros AFTER today
                contributions.append(Completion(date: dateKey, count: 0))
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return contributions
    }
}

