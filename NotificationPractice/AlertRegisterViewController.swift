//
//  AlertRegisterViewController.swift
//  NotificationPractice
//
//  Created by yc on 2021/09/18.
//

import UIKit

class AlertRegisterViewController: UIViewController {

    // 데이터를 이전 화면으로 전달하기(클로저 사용)
    var savedSchedule: ((_ date: Date, _ title: String) -> Void)?
        
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- @IBAction
    @IBAction func tapCancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveBarButton(_ sender: UIBarButtonItem) {
        
        // 데이터 전달
        self.savedSchedule?(self.datePicker.date, self.titleTextField.text!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
