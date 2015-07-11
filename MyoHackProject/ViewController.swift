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

var temp : [CGFloat] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]

class ViewController: UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {

    var xGraph : BEMSimpleLineGraphView!
    var yGraph : BEMSimpleLineGraphView!
    var zGraph : BEMSimpleLineGraphView!
    
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xPoints = temp
        yPoints = temp
        zPoints = temp
        
        TLMHub.sharedHub().attachByIdentifier(myoIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        
        
        xGraph = BEMSimpleLineGraphView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3))
        yGraph = BEMSimpleLineGraphView(frame: CGRectMake(self.view.frame.size.height/3, 0, self.view.frame.size.width, self.view.frame.size.height/3))
        zGraph = BEMSimpleLineGraphView(frame: CGRectMake((self.view.frame.size.height*2)/3, 0, self.view.frame.size.width, self.view.frame.size.height/3))
        
        xGraph.animationGraphStyle = BEMLineAnimation.None
        xGraph.enableBezierCurve = true
        xGraph.dataSource = self
        xGraph.delegate = self
        self.view.addSubview(xGraph)
        
        yGraph.animationGraphStyle = BEMLineAnimation.None
        yGraph.enableBezierCurve = true
        yGraph.dataSource = self
        yGraph.delegate = self
        self.view.addSubview(yGraph)
    
        zGraph.animationGraphStyle = BEMLineAnimation.None
        zGraph.enableBezierCurve = true
        zGraph.dataSource = self
        zGraph.delegate = self
        self.view.addSubview(zGraph)
        
        
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        var orientation = notification.userInfo![kTLMKeyOrientationEvent]! as! TLMOrientationEvent
        
        xPoints.append(CGFloat(orientation.quaternion.x))
        yPoints.append(CGFloat(orientation.quaternion.y))
        zPoints.append(CGFloat(orientation.quaternion.z))
        
        self.refreshGraph(orientation.quaternion)
        
        println("\(orientation.quaternion.x), \(orientation.quaternion.y), \(orientation.quaternion.z), \(orientation.quaternion.w)")
    }
    
    func refreshGraph(quat : TLMQuaternion) {
    
        /*
        if (counter % 10 == 0) {
            if xPoints.count <= 20 {
                xPoints.append(CGFloat(quat.x))
                xGraph.reloadGraph()
            }
            else {
                xPoints.removeAtIndex(0)
                xPoints.append(CGFloat(quat.x))
                xGraph.reloadGraph()
            }
            counter = 0
        }
        counter++
*/
        xGraph.reloadGraph()
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 20
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if graph == xGraph
        {
            return xPoints[xPoints.count - 20 + index]
        }
        else if graph == yGraph
        {
            return yPoints[yPoints.count - 20 + index]
        }
        else
        {
            return zPoints[yPoints.count - 20 + index]
        }
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

}
