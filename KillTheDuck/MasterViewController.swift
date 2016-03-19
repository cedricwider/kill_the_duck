//
//  MasterViewController.swift
//  KillTheDuck
//
//  Created by Cédric Wider on 18/03/16.
//  Copyright © 2016 Cédric Wider. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "masterStatusCell"
    let dataGrabber = DataGrabber()

    var metrics : Array<Metric>? = nil
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.purpleColor()
        refreshControl.tintColor = UIColor.whiteColor()
        return refreshControl
    }()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideTopPadding()
        self.loadMetrics(nil)
    }
    
    func hideTopPadding() {
        var frame = CGRectZero
        frame.size.height = 1;
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.addSubview(refreshControl)
    }
    
    func loadMetrics(refreshControl: UIRefreshControl?) {
        dataGrabber.fetchMetrics() { metrics in
            debugPrint("Received \(metrics.count) metric(s)")
            self.metrics = metrics
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadMetrics(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.metrics = nil
    }

    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        if let statusCell = cell as? StatusCell {
            let metric = self.metrics![indexPath.row]
            statusCell.nameLabel.text = metric.name
            self.dataGrabber.fetchEndpointData(NSURL(string: metric.endpoint)!) { system in
                debugPrint("System \(system.name) with status \(system.status) received at row \(indexPath.row)")
                statusCell.statusImage.image = self.getImageForStatus(system.status)
            }
        }
        return cell
    }
    
    func getImageForStatus(status: System.Status) -> UIImage {
        switch status {
        case .OK:
            return UIImage(named: "green_dot")!
        case .WARNING:
            return UIImage(named: "yellow_dot")!
        default:
            return UIImage(named: "red_dot")!
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let metrics = self.metrics {
            return metrics.count
        } else {
            return 0
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

