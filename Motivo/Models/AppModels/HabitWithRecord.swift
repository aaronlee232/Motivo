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
    var rejectVotes: [VoteModel]  // No use for accept votes yet
    
    init(habit: HabitModel, record: HabitRecord, votes: [VoteModel]=[]) {
        self.habit = habit
        self.record = record
        self.rejectVotes = votes
    }
    
    var isCompleted: Bool {
        let completedCount = record.completedCount
        return completedCount >= habit.goal
    }

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
        guard let recordDate = ISO8601DateFormatter().date(from: record.timestamp) else {
            return false
        }

        let calendar = Calendar.current
        let now = Date()

        var startDate: Date
        var endDate: Date

        switch habit.frequency {
        case FrequencyConstants.daily:
            startDate = calendar.startOfDay(for: recordDate)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: recordDate)!

        case FrequencyConstants.weekly:
            startDate = DateUtils.shared.getStartOfWeek(for: recordDate)
            endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!

        case FrequencyConstants.monthly:
            startDate = DateUtils.shared.getStartOfMonth(for: recordDate)
            endDate = DateUtils.shared.getEndOfMonth(for: recordDate)

        default:
            return false
        }

        return (now >= startDate) && (now <= endDate)
    }


    var isLate: Bool {
        guard let recordDate = ISO8601DateFormatter().date(from: record.timestamp) else {
            return false
        }

        let now = Date()
        let deadlineDate: Date

        switch habit.frequency {
        case FrequencyConstants.daily:
            deadlineDate = DateUtils.shared.getDeadlineDate(forDailyDeadline: habit.deadline, relativeTo: recordDate)

        case FrequencyConstants.weekly:
            deadlineDate = DateUtils.shared.getDeadlineDate(forWeeklyDeadline: habit.deadline, relativeTo: recordDate)

        case FrequencyConstants.monthly:
            deadlineDate = DateUtils.shared.getDeadlineDate(forMonthlyDeadline: habit.deadline, relativeTo: recordDate)

        default:
            return false
        }

        return now > deadlineDate
    }

}
