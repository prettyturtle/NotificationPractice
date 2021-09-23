/*
 푸시 알림
 - 언제? (날짜, 시간, 장소)
 - 알림 허가
 - 알림 종류(알림이 어떻게 생겼나)
 - 알림 추가
 - 알림 삭제
 */

import UIKit
//import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 알림을 관장하는 UNUserNotificationCenter
    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 아래에 만들어 놓은 델리게이트
        userNotificationCenter.delegate = self
        
        /*
         앱이 실행할 때,
         사용자가 알림을 받게 하려면 사용자에게 허가 받아야함
         1. 뭘 허가 받을 거임?
         2. 허가 요청
         3. 에러 처리
         */
        
        let authrizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authrizationOptions) { _, error in
            if let error = error {
                print("""
                        사용자의 인증을 받다가 에러가 났습니다.
                        에러 내용은 \(error.localizedDescription)입니다.
                    """)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// 알림 보낼 때 필요한 델리게이트
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        /*
         // 어떻게 보낼거냐??
         .badge : 아이콘 우측 상단에 뜨는 빨간색 알림 표시,
         .list : 알림센터(화면 위에서 아래로 내리면 나오는 곳)에 알림 띄우기,
         .banner : 화면 상단(배너)에 짜잔 하고 띄우기,
         .sound : 소리와 같이
         */
        completionHandler([.badge, .list, .banner, .sound])
    }
    
    // 사용자가 푸시알림을 눌렀을 때(반응할 때)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
