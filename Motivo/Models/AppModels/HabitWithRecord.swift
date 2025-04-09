//
//  HabitEntry.swift
//  Motivo
//
//  Created by Aaron Lee on 4/9/25.
//

import Foundation

struct HabitWithRecord {
    var habit: HabitModel
    var record: HabitRecord
    
    var status: HabitStatus {
        if (record.verifiedPhotoURLs.count >= habit.goal) {
            // Task is complete if there are the same number of verified photos as goal
            return HabitStatus.complete
        } else if (!record.unverifiedPhotoURLs.isEmpty) {
            // Task is pending if task is not complete, and there are unverified photos
            return HabitStatus.pending
        } else {
            // Task is incomplete if task is not complete if number of unverified photos is < goal
            // AND there are no unverified photos
            return HabitStatus.incomplete
        }
    }
    
    var isActive: Bool {
        // Defines the window for "active" habit records
        var startDate: Date
        var deadlineDate: Date
        switch habit.frequency {
        case FrequencyConstants.daily:
            deadlineDate = DateUtils.shared.getDeadlineDate(forDailyDeadline: habit.deadline)
            startDate = DateUtils.shared.getStartDate(forDailyDeadlineDate: deadlineDate)
        case FrequencyConstants.weekly:
            deadlineDate = DateUtils.shared.getDeadlineDate(forWeeklyDeadline: habit.deadline)
            startDate = DateUtils.shared.getStartDate(forWeeklyDeadlineDate: deadlineDate)
        case FrequencyConstants.monthly:
            deadlineDate = DateUtils.shared.getDeadlineDate(forMonthlyDeadline: habit.deadline)
            startDate = DateUtils.shared.getStartDate(forMonthlyDeadlineDate: deadlineDate)
        default:
            fatalError("This should not have happened. \"\(habit.frequency)\" is an invalid frequency.")
        }
        
        // Check if record is active based on timestamp and deadline
        let isAfterStart = ISO8601DateFormatter().date(from: record.timestamp)! >= startDate
        let isBeforeDeadline = ISO8601DateFormatter().date(from: record.timestamp)! <= deadlineDate
        
        return isAfterStart && isBeforeDeadline
    }
}
