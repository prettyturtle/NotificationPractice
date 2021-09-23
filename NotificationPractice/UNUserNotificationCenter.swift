//
//  UNUserNotificationCenter.swift
//  NotificationPractice
//
//  Created by yc on 2021/09/18.
//

import Foundation
import UserNotifications


// 알림 추가하는 함수 만들기
extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert) {
        // 알림이 어떻게 생겼을까
        let content = UNMutableNotificationContent()
        content.title = "\(alert.title)"
        content.body = "오늘 세운 목표는 꼭 달성하기 👊"
        content.sound = .default
        content.badge = 1
        
        // 입력된 alert의 date에서 [시간, 분]을 가져와 dateComponent로 만든다
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        // 만들어둔 component에 의해서 알림이 가도록 하는 방아쇠(trigger) 같은거
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        // 각 알림들은 고유한 id를 갖고 있다(전에 만들었던 UUId). 그 알림들에 대해서 각각 어떻게 생겼는지, 무엇이 방아쇠인지(어떨때 알림이 올건지) 정해서 알림을 만들었다
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)

        // 알림 추가
        self.add(request, withCompletionHandler: nil)
    }
}
