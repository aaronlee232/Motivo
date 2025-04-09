//
//  DateUtils.swift
//  Motivo
//
//  Created by Aaron Lee on 4/9/25.
//

import Foundation

class DateUtils {
    // Deadline property
    // "HH:mm" for daily (e.g. "23:00")
    // "weekday" ("1" ... "7") for weekly
    // "day of month" ("1"..."31") for monthly (e.g. "15" = 15th)
    
    static let shared = DateUtils()
    
    private init() {}
    
    // Daily deadline — "HH:mm"
    func getDeadlineDate(forDailyDeadline: String) -> Date {
        let now = Date()
        let calendar = Calendar.current
        
        // Convert deadline string to hour and minute ints
        let timeParts = forDailyDeadline.split(separator: ":")
        guard timeParts.count == 2,
              let hour = Int(timeParts[0]),
              let minute = Int(timeParts[1]) else {
            fatalError("Invalid time format. Use HH:mm (e.g. 23:00)")
        }
        
        // Create current active deadline
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 59
        
        return calendar.date(from: components)!
    }
    
    // Weekly deadline — "1" to "7" (1 = Sunday, 7 = Saturday)
    func getDeadlineDate(forWeeklyDeadline: String) -> Date {
        let now = Date()
        let calendar = Calendar.current
        
        // Convert deadline string to Int (1 = Sunday, 7 = Saturday)
        guard let targetWeekday = Int(forWeeklyDeadline), (1...7).contains(targetWeekday) else {
            fatalError("Invalid weekday value. Must be between 1 (Sunday) and 7 (Saturday)")
        }

        // Find the most recent Sunday (start of current week)
        let currentWeekday = calendar.component(.weekday, from: now)
        let daysSinceSunday = currentWeekday - 1
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceSunday, to: now)!
        
        // Add (targetWeekday - 1) days to get the deadline day in this week
        let deadlineDate = calendar.date(byAdding: .day, value: targetWeekday - 1, to: startOfWeek)!
        
        // Set deadline time to 23:59:59
        var components = calendar.dateComponents([.year, .month, .day], from: deadlineDate)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.date(from: components)!
    }
    
    // Gets the actual deadline for monthly habits.
    // ex: Replaces 31 with 28 if last day is 28th
    // Monthly deadline — "1" to "31"
    func getDeadlineDate(forMonthlyDeadline: String) -> Date {
        let now = Date()
        let calendar = Calendar.current
        
        // Convert deadline string to day int
        guard let habitDay = Int(forMonthlyDeadline) else {
            fatalError("Invalid day string passed: \(forMonthlyDeadline)")
        }
        
        // Calculate monthly deadline
        let range = calendar.range(of: .day, in: .month, for: now)!
        let maxDay = range.count
        let deadlineDay = min(habitDay, maxDay)
        
        // Create current active deadline
        var components = calendar.dateComponents([.year, .month], from: now)
        components.day = deadlineDay
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.date(from: components)!
    }
    
    func getStartDate(forDailyDeadlineDate: Date) -> Date {
        return Calendar.current.startOfDay(for: forDailyDeadlineDate)
    }
    
    func getStartDate(forWeeklyDeadlineDate: Date) -> Date {
        let calendar = Calendar.current

        // Get weekday (1 = Sunday, 7 = Saturday)
        let weekday = calendar.component(.weekday, from: forWeeklyDeadlineDate)
        
        // Go back to the most recent Sunday
        let daysToSubtract = weekday - 1
        let sunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: forWeeklyDeadlineDate)!
        
        // Set time to 00:00:00
        return calendar.startOfDay(for: sunday)
    }
    
    func getStartDate(forMonthlyDeadlineDate: Date) -> Date {
        let now = Date()
        let calendar = Calendar.current
        
        // Create start day as first day of the month
        var components = calendar.dateComponents([.year, .month], from: now)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
}
