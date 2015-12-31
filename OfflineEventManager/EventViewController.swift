//
//  EventViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 16..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var textService: UITextField!
    
    var serviceType: String?
    var menuNames = [String]()
    var menuValues = [String]()
    var menuValue: String?
    var eventList: JSON?
    var tableEvent: UITableView?
    let reuseIdentifier: String = "eventCell"

    
    @IBAction func searchEventList(sender: AnyObject) {
        if menuValue == "" {
            let alert = UIAlertController(title: "알림", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
            let selectServiceAlertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in print("need to select service")}
            
            alert.addAction(selectServiceAlertAction)
            alert.message = "서비스를 선택해 주세요."
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            if menuValue != nil {
                RestApiManager.sharedInstance.getEventList(serviceType!, serviceName: menuValue!) {json in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.eventList = json["eventList"]
                        self.tableEvent?.reloadData()
                    })
                }
            }
        }
    }
    
    @IBAction func returnEventView(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        menuNames = ["서비스 선택", "리니지", "리니지2", "아이온", "블레이드앤소울", "MXM", "PlayNC"]
        menuValues = ["", "lineage", "lineage2", "aion", "bns", "mxm", "plaync"]
        
        let selectPickerView = UIPickerView()
        
        selectPickerView.delegate = self
        textService.inputView = selectPickerView
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "서비스 선택"
        label.textAlignment = NSTextAlignment.Center

        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace, textBtn, flexSpace, doneButton], animated: true)
        
        textService.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let frame:CGRect = CGRect(x: 0, y: 160, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableEvent = UITableView(frame: frame)
        self.tableEvent?.dataSource = self
        self.tableEvent?.delegate = self
        self.view.addSubview(self.tableEvent!)
    }

    func donePressed(sender: UIBarButtonItem) {
        textService.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menuNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            menuValue = ""
            textService.text = ""
        } else {
            menuValue = menuValues[row]
            textService.text = menuNames[row]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventList != nil {
            if eventList!.isEmpty == true {
                return 1
            }
            
            return eventList!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        }

        if eventList != nil {
            if eventList!.isEmpty == true {
                cell!.textLabel?.text = "등록된 이벤트가 없습니다."
            } else {
                let event: JSON = eventList![indexPath.row]
                cell!.textLabel?.text = event["eventName"].string
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if eventList != nil && eventList!.isEmpty == false {
            let event: JSON = eventList![indexPath.row]
            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("EventDetailView") as! EventDetailViewController
            
            nextView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            nextView.serviceType = self.serviceType
            nextView.eventId = event["eventId"].intValue
            
            self.presentViewController(nextView, animated: true, completion: nil)
        }
    }
}
