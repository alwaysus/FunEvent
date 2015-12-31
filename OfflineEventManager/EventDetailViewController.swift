//
//  EventDetailViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 21..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelServiceName: UILabel!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelEventDescription: UILabel!
    
    var serviceType: String?
    var eventId: Int?
    var entryList: JSON?
    var tableEntry: UITableView?
    let reuseIdentifier: String = "entryCell"
    
    @IBAction func returnEventDetailView(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if eventId > 0 {
            RestApiManager.sharedInstance.getEventDetail(serviceType!, eventId: eventId!) {json in
                dispatch_async(dispatch_get_main_queue(), {
                    let event: JSON = json["event"]
                    let eventDate: NSString = event["eventDate"].string!
                    
                    self.labelServiceName.text = event["serviceName"].string
                    self.labelEventName.text = event["eventName"].string
                    self.labelEventDate.text = eventDate.substringToIndex(4) + "-" + eventDate.substringWithRange(NSMakeRange(4, 2)) + "-" + eventDate.substringFromIndex(6)
                    self.labelEventDescription.text = event["description"].string
                    self.entryList = json["entryList"]
                    
                    self.tableEntry?.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let frame:CGRect = CGRect(x: 0, y: 270, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.tableEntry = UITableView(frame: frame)
        self.tableEntry?.dataSource = self
        self.tableEntry?.delegate = self
        self.view.addSubview(self.tableEntry!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entryList != nil {
            if entryList!.isEmpty == true {
                return 1
            }
            
            return entryList!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        }
        
        if entryList != nil {
            if entryList!.isEmpty == true {
                cell!.textLabel?.text = "등록된 참여항목이 없습니다."
            } else {
                let entry: JSON = entryList![indexPath.row]
                cell!.textLabel?.text = entry["entryName"].string
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if entryList != nil && entryList!.isEmpty == false {
            let entry: JSON = entryList![indexPath.row]
            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("EntryView") as! EntryViewController
            
            nextView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            nextView.serviceType = self.serviceType
            nextView.entryId = entry["entryId"].intValue
            nextView.serviceName = self.labelServiceName.text
            nextView.eventName = self.labelEventName.text
            nextView.eventDate = self.labelEventDate.text
            
            self.presentViewController(nextView, animated: true, completion: nil)
        }
    }
}
