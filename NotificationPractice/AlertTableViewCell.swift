//
//  AlertTableViewCell.swift
//  NotificationPractice
//
//  Created by yc on 2021/09/18.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleAlertSwitch(_ sender: UISwitch) {
        
        /*
         토글이 꺼지면 알림을 삭제하고
         켜지면 알림을 추가해야한다
         근데 여기서는 무슨 알람을 추가해야하는지 모른다
         그래서 토글의 tag에 고유한 번호를 부여한다(indexPath.row)
         그 번호로 알림 추가 삭제 ㄱㄱ
         */
        
        // 일단 유저 저장소에서 "alerts"라는 이름의 배열들을 쭉 가져온다(가져올땐? : decode)
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        
        // 저장소에서 가져온 배열에서 토글된 버튼을 tag를 통해 찾고 isOn 값을 변경해준다
        alerts[sender.tag].isOn = sender.isOn
        // 그리고 저장 (저장할 땐? : encode)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        // 알림 추가
        if sender.isOn {
            // true 이면? : alerts 배열에서 true가 된 토글을 tag를 통해 무슨 알림(Alert 타입)인지 찾고 그 알림을 추가한다
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else {
            // false 이면? : alerts 배열에서 false가 된 토글을 tag를 통해 찾고 그 알림의 id값으로 예약된 알림을 삭제한다
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
}
