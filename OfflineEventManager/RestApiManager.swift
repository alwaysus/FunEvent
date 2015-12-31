//
//  RestApiManager.swift
//  OfflineEventManager
//
//  Created by ncsoft on 2015. 12. 17..
//  Copyright © 2015년 ncsoft. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let apiURL: String = "http://rc.mobile.plaync.com/api/offline/"
    
    func getRouteUrl(serviceType: String, path: String) -> String {
        return apiURL + path
    }
    
    func getEventList(serviceType: String, serviceName: String, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: serviceName + "/eventlist")
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getEventDetail(serviceType: String, eventId: Int, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: "event/" + String(eventId))
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getEventUser(serviceType: String, eventId: Int, barcodeNo: String, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: "eventuser/" + String(eventId) + "/" + barcodeNo)
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getEntryHistory(serviceType: String, entryId: Int, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: "entry/" + String(entryId) + "/history")
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getUserHistory(serviceType: String, barcoceNo: String, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: "user/" + barcoceNo + "/history")
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func participateEvent(serviceType: String, entryId: Int, barcodeNo: String, onCompletion: (JSON) -> Void) {
        let route = self.getRouteUrl(serviceType, path: "participate/" + String(entryId) + "/" + barcodeNo)
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json: JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        
        task.resume()
    }
}