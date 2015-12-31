//
//  ViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 11..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textAccount: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        let account: String = textAccount.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let password: String = textPassword.text!
        
        if account == "admin" && password == "admin" {
            let serviceType: String = "event"
            
            let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("EventView") as! EventViewController
            
            menuView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            menuView.serviceType = serviceType
            
            self.presentViewController(menuView, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "알림", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
            let loginAlertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in print("invalid login")}
            
            alert.addAction(loginAlertAction)
            
            if account == "" {
                alert.message = "계정을 입력해 주세요."
            } else if password == "" {
                alert.message = "비밀번호를 입력해 주세요."
            } else {
                alert.message = "로그인 정보가 정확하지 않습니다."
            }
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

