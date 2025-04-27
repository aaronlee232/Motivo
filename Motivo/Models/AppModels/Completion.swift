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
    static func generate(forPastMonths pastMonths: Int) -> [Completion] {
        var contributions: [Completion] = []
        let toDate = DateUtils.shared.calendar.startOfDay(for: Date.now)
        let fromDate = Calendar.current.date(byAdding: .month, value: -pastMonths, to: toDate)!

        var currentDate = fromDate
        while currentDate <= toDate {
            let contribution = Completion(date: currentDate, count: Float.random(in: 0...1))
            contributions.append(contribution)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return contributions
    }
    
    static func fillGenerate(sparseContributions: [Completion], forPastMonths pastMonths: Int) -> [Completion] {
        var contributions = Dictionary(
            uniqueKeysWithValues: sparseContributions.map { ($0.date, $0) }
        )
        //ISO8601DateFormatter().string(from: Date())
        
        let toDate = Date.now
        let fromDate = Calendar.current.date(byAdding: .month, value: -pastMonths, to: toDate)!
        
        var currentDate = fromDate
        while currentDate <= toDate {
            // Skip days that already have contribution
            if (contributions.keys.contains(currentDate)) {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                continue
            }
            
            let contribution = Completion(date: currentDate, count: Float.random(in: 0...1))
            contributions[currentDate] = contribution
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        currentDate = fromDate
        var completeContributions: [Completion] = []
        while currentDate <= toDate {
            completeContributions.append(contributions[currentDate]!)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return completeContributions
    }
}

