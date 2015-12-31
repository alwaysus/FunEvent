//
//  EntryViewController.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 21..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelServiceName: UILabel!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelEntryName: UILabel!
    @IBOutlet weak var textBarcodeNo: UITextField!
    
    var serviceType: String?
    var entryId: Int?
    var serviceName: String?
    var eventName: String?
    var eventDate: String?
    var historyList: JSON?
    var tableHistory: UITableView?
    let reuseIdentifier: String = "historyCell"
    
    @IBAction func participateEntry(sender: AnyObject) {
        let barcodeNo: String = textBarcodeNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if entryId > 0 {
            if barcodeNo == "" {
                let alert = UIAlertController(title: "알림", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
                let emptyBarcodeNoAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) {
                    (UIAlertAction) -> Void in print("empty barcode number.")}
                
                alert.addAction(emptyBarcodeNoAction)
                alert.message = "바코드 번호를 입력해 주세요."
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("ResultView") as! ResultViewController
                
                nextView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
                nextView.serviceType = self.serviceType
                nextView.entryId = self.entryId
                nextView.barcodeNo = barcodeNo
                
                self.presentViewController(nextView, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func barcodeScan(sender: AnyObject) {
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeView") as! BarcodeViewController
        
        nextView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        nextView.serviceType = self.serviceType
        nextView.entryId = self.entryId
        
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    @IBAction func returnEntryView(segue:UIStoryboardSegue) {
        self.textBarcodeNo.text = ""
        self.entryHistory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelServiceName.text = serviceName
        labelEventName.text = eventName
        labelEventDate.text = eventDate
        textBarcodeNo.keyboardType = UIKeyboardType.NumberPad
        
        self.entryHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let frame:CGRect = CGRect(x: 0, y: 310, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.tableHistory = UITableView(frame: frame)
        self.tableHistory?.dataSource = self
        self.tableHistory?.delegate = self
        self.view.addSubview(self.tableHistory!)
    }
    
    func entryHistory() {
        if entryId > 0 {
            RestApiManager.sharedInstance.getEntryHistory(serviceType!, entryId: entryId!) {json in
                dispatch_async(dispatch_get_main_queue(), {
                    let entry: JSON = json["entry"]
                    self.labelEntryName.text = entry["entryName"].string
                    self.historyList = json["historyList"]
                    self.tableHistory?.reloadData()
                })
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyList != nil {
            if historyList!.isEmpty == true {
                return 1
            }
            
            return historyList!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        }
        
        if historyList != nil {
            if historyList!.isEmpty == true {
                cell!.textLabel?.text = "아직 참여기록이 없습니다."
            } else {
                let history: JSON = historyList![indexPath.row]
                let registerTime: String = (history["registerTime"].string! as NSString).substringToIndex(19)
                let historyText: String = registerTime + "   |   " + history["portalName"].string!
                cell!.textLabel?.text = historyText
            }
        }
        
        return cell!
    }
}
