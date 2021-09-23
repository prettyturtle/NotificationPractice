//
//  ViewController.swift
//  NotificationPractice
//
//  Created by yc on 2021/09/18.
//

import UIKit
import UserNotifications

class AlertListViewController: UITableViewController {

    var alerts: [Alert] = []
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // alerts 배열을 유저 저장소에서 가져온 alerts배열로 만들어줌
        alerts = alertListInUserDefaults()
        
    }

    // MARK:- @IBAction
    
    // 데이터 주고 받기 & 화면 전환
    @IBAction func tapAddAlertBarButton(_ sender: UIBarButtonItem) {
        guard let alertRegisterVC = self.storyboard?.instantiateViewController(identifier: "AlertRegisterViewController") as? AlertRegisterViewController else { return }
        
        alertRegisterVC.savedSchedule = { [weak self] date, title in
            guard let self = self else { return }
            
            // alertsList 배열을 유저 저장소에서 가져온 "alerts" 배열로 만들어줌
            var alertsList = self.alertListInUserDefaults()
            // 데이터를 전달 받으면 Alert형식의 인스턴스 생성
            let newAlert = Alert(date: date, title: title, isOn: true)
            // newAlert를 alertsList에 저장( 이때 alertsList는 유저 저장소에서 가져온 배열이다. 하지만 여기에 append한다고 해도 유저 저장소에 저장한 것은 아니다 )
            alertsList.append(newAlert)
            alertsList.sort { $0.date < $1.date }

            // 배열 덮어쓰기
            self.alerts = alertsList
            
            /*
             유저 저장소에 ㄹㅇ로 데이터 저장하기
             (데이터를 유저 저장소에 저장할 때는 인코딩을 하고 저장해야한다)
             (key는 "alerts"로 저장)
             */
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            // 푸시 알림 추가
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        
        self.present(alertRegisterVC, animated: true, completion: nil)
    }
}

// MARK:- other Functions
extension AlertListViewController {
    func alertListInUserDefaults() -> [Alert] {
        /*
         1. UserDefaults의 standard (사용자 휴대폰의 저장소)에서
         "alerts"라는 키를 가진 데이터를 읽어오기(value)
         
         2. 가져온 데이터를 바로 사용할 수는 없고
         데이터를 Decode해서 사용해야한다
         (decode하기 위해서는 Alert 구조체가 Codable 프로토콜을 채택해야함)
         */
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        
        return alerts
    }
}




// MARK:- 테이블 뷰
extension AlertListViewController {
    // 몇 개?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    // 누구를?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell") as? AlertTableViewCell else { return UITableViewCell() }
        
        // 전달받은 데이터를 형식에 맞게 셀로 만들기
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.dateLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        cell.titleLabel.text = alerts[indexPath.row].title
        
        // cell의 각각 tag의 고유하게 자리 번호를 부여
        cell.alertSwitch.tag = indexPath.row
        
        
                
        return cell
    }
    // 높이는?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // 행 중간에 나누어 title을 정의
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "📚 오늘의 일정을 추가하세요!!"
        default:
            return nil
        }
    }
    // 셀을 좌우로 스크롤 하고싶으면 허락(true)해줘야함
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            /*
             유저 저장소에서 삭제(alerts 배열에서 없앴으니, 이 배열을 유저 저장소 "alerts"로 저장)
             (유저 저장소에 저장할 때는? : 인코딩하고 저장 !!)
             */
            
            // 곧 있을(pending)알람들에서 제거한다. (고유한 아이디 값으로 찾아서 삭제한다)
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            
            // 가장 나중에 배열에서 삭제하는 걸로 해야함(why? : 배열의 인덱스값으로 id를 찾아 알림을 삭제하는데 먼저 배열에서 빼버리면 인덱스 range 오류남)
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")

            
            self.tableView.reloadData()
        default:
            break
        }
    }
}
