//
//  ResultViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 29..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var labelResultMessage: UILabel!
    @IBOutlet weak var labelAccountName: UILabel!
    @IBOutlet weak var labelNickName: UILabel!
    
    var serviceType: String?
    var entryId: Int?
    var barcodeNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if entryId > 0 {
            RestApiManager.sharedInstance.participateEvent(serviceType!, entryId: entryId!, barcodeNo: barcodeNo!) {json in
                dispatch_async(dispatch_get_main_queue(), {
                    if json != nil {
                        var resultMessage: String = ""
                        self.labelAccountName.text = json["accountName"].string!
                        self.labelNickName.text = json["portalName"].string!
                        
                        switch json["result"].string! {
                        case "success" :
                            resultMessage = "참여 확인이 완료되었습니다."
                        case "user_not_found" :
                            resultMessage = "해당 고객 정보를 찾을 수 없습니다."
                        case "entry_not_found" :
                            resultMessage = "참여 항목을 다시 확인해 주세요."
                        case "already_entry" :
                            resultMessage = "이미 참여 확인을 완료하셨습니다."
                        case "fail" :
                            resultMessage = "참여 확인이 실패하였습니다."
                        default :
                            resultMessage = "잠시 후 다시 시도해주세요."
                        }
                        
                        self.labelResultMessage.text = resultMessage
                    } else {
                        self.labelResultMessage.text = "잠시 후 다시 시도해주세요."
                    }
                })
            }
        } else {
            self.labelResultMessage.text = "잠시 후 다시 시도해주세요."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
