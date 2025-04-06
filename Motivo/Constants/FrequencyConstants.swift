//
//  FrequencyConstants.swift
//  Motivo
//
//  Created by Aaron Lee on 4/6/25.
//

struct FrequencyConstants {
    static let daily = "Daily"
    static let weekly = "Weekly"
    static let monthly = "Monthly"
    
    static var frequencies: [String] {
        return [FrequencyConstants.daily, FrequencyConstants.weekly, FrequencyConstants.monthly]
    }
}
