//
//  Alert.swift
//  NotificationPractice
//
//  Created by yc on 2021/09/18.
//

import Foundation

// Codable : 인코딩, 디코딩하기 위해 채택해야하는 프로토콜
struct Alert: Codable {
    var id: String = UUID().uuidString
    let date: Date
    let title: String
    var isOn: Bool
    
    // 주어진 날짜를 "몇시:몇분" 형식으로 바꾸어 반환
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    // 주어진 날짜를 "오전" 또는 "오후" 형식으로 바꾸어 반환
    var meridiem: String {
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a"
        meridiemFormatter.locale = Locale(identifier: "ko")
        return meridiemFormatter.string(from: date)
    }
}
