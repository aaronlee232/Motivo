//
//  DateUtils.swift
//  Motivo
//
//  Created by Aaron Lee on 4/9/25.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()
    private init() {}

    // MARK: - Daily deadline — "HH:mm"
    func getDeadlineDate(forDailyDeadline dailyDeadline: String, relativeTo date: Date = Date()) -> Date {
        let calendar = Calendar.current

        let timeParts = dailyDeadline.split(separator: ":")
        guard timeParts.count == 2,
              let hour = Int(timeParts[0]),
              let minute = Int(timeParts[1]) else {
            fatalError("Invalid time format. Use HH:mm (e.g. 23:00)")
        }

        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        components.second = 59

        return calendar.date(from: components)!
    }

    // MARK: - Weekly deadline — "1" (Sunday) to "7" (Saturday)
    func getDeadlineDate(forWeeklyDeadline weeklyDeadline: String, relativeTo date: Date = Date()) -> Date {
        let calendar = Calendar.current

        guard let targetWeekday = Int(weeklyDeadline), (1...7).contains(targetWeekday) else {
            fatalError("Invalid weekday value of \(weeklyDeadline). Must be between 1 (Sunday) and 7 (Saturday)")
        }

        let currentWeekday = calendar.component(.weekday, from: date)
        let daysSinceSunday = currentWeekday - 1
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceSunday, to: date)!

        let deadlineDay = calendar.date(byAdding: .day, value: targetWeekday - 1, to: startOfWeek)!

        var components = calendar.dateComponents([.year, .month, .day], from: deadlineDay)
        components.hour = 23
        components.minute = 59
        components.second = 59

        return calendar.date(from: components)!
    }

    // MARK: - Monthly deadline — "1" to "31"
    func getDeadlineDate(forMonthlyDeadline monthlyDeadline: String, relativeTo date: Date = Date()) -> Date {
        let calendar = Calendar.current

        guard let habitDay = Int(monthlyDeadline) else {
            fatalError("Invalid day string passed: \(monthlyDeadline)")
        }

        let range = calendar.range(of: .day, in: .month, for: date)!
        let maxDay = range.count
        let clampedDay = min(habitDay, maxDay)

        var components = calendar.dateComponents([.year, .month], from: date)
        components.day = clampedDay
        components.hour = 23
        components.minute = 59
        components.second = 59

        return calendar.date(from: components)!
    }

    // MARK: - Period Anchors
    func getStartOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = weekday - 2 // Assuming Monday = 2
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
        return calendar.startOfDay(for: startOfWeek)
    }

    func getStartOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: date)
        components.day = 1
        return calendar.date(from: components)!
    }

    func getEndOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        var components = calendar.dateComponents([.year, .month], from: date)
        components.day = range.count
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)!
    }
}
