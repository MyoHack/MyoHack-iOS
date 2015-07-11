//
//  ViewController.swift
//  MyoHackProject
//
//  Created by ISMAIL J MUSTAFA on 7/11/15.
//  Copyright (c) 2015 MyoHack. All rights reserved.
//

import UIKit

var myoIdentifier : NSUUID = NSUUID(UUIDString: "0A66A6EA-D5D1-F872-E701-49AD2FFC45E4")!
var xPoints : [CGFloat] = [0.0]
var yPoints : [CGFloat] = [0.0]
var zPoints : [CGFloat] = [0.0]

class ViewController: UIViewController {

    var lineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TLMHub.sharedHub().attachByIdentifier(myoIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
    
        xPoints = [1,2,3,4,5]
        
        // line chart
        lineChart = LineChart(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2))
        lineChart.area = true
        lineChart.animation.enabled = false
        lineChart.x.grid.count = 1
        lineChart.y.grid.count = 1
        lineChart.addLine(xPoints)
        view.addSubview(lineChart)
        
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        var orientation = notification.userInfo![kTLMKeyOrientationEvent]! as! TLMOrientationEvent
        
        refreshGraph(orientation.quaternion)
        
        println("\(orientation.quaternion.x), \(orientation.quaternion.y), \(orientation.quaternion.z), \(orientation.quaternion.w)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.modalPresentMyoSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modalPresentMyoSettings() {
        var settings : UINavigationController = TLMSettingsViewController.settingsInNavigationController()
        self.presentViewController(settings, animated: true) { () -> Void in
            
        }
    }

    func refreshGraph(quat : TLMQuaternion)
    {
        lineChart.clearAll()
        lineChart.removeFromSuperview()
        if xPoints.count > 20
        {
            xPoints.removeAtIndex(0)
        }
        xPoints.append(CGFloat(quat.x))
        
        view.addSubview(lineChart)
    }

}
