//
//  MenuSelectViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 16..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class MenuSelectViewController: UIViewController {
    
    var menuNames = [String]()

    @IBOutlet weak var tableMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        menuNames = ["리니지", "리니지2", "아이온", "블레이드앤소울", "MXM", "PlayNC"]
        //tableView.estimatedRowHeight = 35
        
        let device = UIDevice.currentDevice()
        let iosVersion = NSString(string: device.systemVersion).doubleValue
        
        if (iosVersion > 7) {
            self.tableMenu.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
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
