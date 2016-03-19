//
//  DataSource.swift
//  KillTheDuck
//
//  Created by Cédric Wider on 18/03/16.
//  Copyright © 2016 Cédric Wider. All rights reserved.
//

import Foundation
import Alamofire

class DataGrabber {
    
    let overViewURL = NSURL(string: "http://www.mocky.io/v2/56ec2a3f110000ff008e8d58")
    // let overViewURL = NSURL(string: "http://3df0ed48.ngrok.com/metrics")
    
    func fetchMetrics(callback: (Array<Metric>) -> Void) {
        var systemNames = Array<Metric>()
        Alamofire.request(.GET, overViewURL!).responseData( { response in
            for metric in self.extractMetricsFromResponse(response.data!) {
                systemNames.append(metric)
            }
            callback(systemNames)
        })
    }
    
    
    func fetchStatusFor(metric: Metric, callback: (System) -> Void) {
        Alamofire.request(.GET, NSURL(string: metric.endpoint)!).responseData( { response in
            if let json : NSDictionary = self.jsonAsDictionary(response.data!) {
                let dataDict = json["data"] as! NSDictionary
                callback(System(state: dataDict["status"] as! String, name: json["key"] as! String))
            }
        })
    }
    
    
    func extractMetricsFromResponse(jsonData: NSData) -> Array<Metric> {
        var retVal = Array<Metric>()
        if let json: NSDictionary = jsonAsDictionary(jsonData) {
            if let metrics = json["metrics"] as? NSArray {
                for metricData in metrics {
                    if let metric = metricData as? NSDictionary {
                        debugPrint("Item: \(metric["endpoint"])")
                        let tmpMetric = Metric(name: metric["key"] as! String, endpoint: metric["endpoint"] as! String)
                        retVal.append(tmpMetric)
                    }
                }
            }
        }
        return retVal;
    }
    
    func fetchEndpointData(fromUrl: NSURL, callback: (System) -> Void) {
        Alamofire.request(.GET, fromUrl).responseData({
            response in
            if let json: NSDictionary = self.jsonAsDictionary(response.data!) {
                let name = json["key"] as! String
                let data = json["data"] as! NSDictionary
                let status = data["status"] as! String
                callback(System(state: status, name: name))
            }
        })
    }
    
    func jsonAsDictionary(jsonData: NSData) -> NSDictionary? {
        if let dict = try? (NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary) {
            return dict
        }
        return nil
    }
}