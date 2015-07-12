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
var wPoints : [CGFloat] = [0.0]

var counter = 0
var rightHitToggle = false

var temp : [CGFloat] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

class ViewController: UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {

    var xGraph : BEMSimpleLineGraphView!
    var yGraph : BEMSimpleLineGraphView!
    var zGraph : BEMSimpleLineGraphView!
    var wGraph : BEMSimpleLineGraphView!
    
    let ws = WebSocket(url: "ws://45.55.88.179:3000/websocket")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xPoints = temp
        yPoints = temp
        zPoints = temp
        wPoints = temp
        
        self.openSocket()
        
        TLMHub.sharedHub().attachByIdentifier(myoIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePoseChange:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveGyroChange:", name: TLMMyoDidReceiveGyroscopeEventNotification, object: nil)
        
        xGraph = BEMSimpleLineGraphView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/4))
        yGraph = BEMSimpleLineGraphView(frame: CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/4))
        zGraph = BEMSimpleLineGraphView(frame: CGRectMake(0, (self.view.frame.size.height*2)/4, self.view.frame.size.width, self.view.frame.size.height/4))
        wGraph = BEMSimpleLineGraphView(frame: CGRectMake(0, (self.view.frame.size.height*3)/4, self.view.frame.size.width, self.view.frame.size.height/4))
        
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
        
        wGraph.animationGraphStyle = BEMLineAnimation.None
        wGraph.enableBezierCurve = true
        wGraph.dataSource = self
        wGraph.delegate = self
        self.view.addSubview(wGraph)
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        var orientation = notification.userInfo![kTLMKeyOrientationEvent]! as! TLMOrientationEvent
       
        self.refreshGraph(orientation.quaternion)
        
        /*
        println("\(orientation.quaternion.x), \(orientation.quaternion.y), \(orientation.quaternion.z), \(orientation.quaternion.w)")
        */
    }
    
    func didReceivePoseChange(notification: NSNotification) {
        var pose = notification.userInfo![kTLMKeyPose]! as! TLMPose
        println(pose.type)
    }
    
    func didReceiveGyroChange(notification: NSNotification) {
        var gyro = notification.userInfo![kTLMKeyGyroscopeEvent]! as! TLMGyroscopeEvent
        
        self.sendMovementWith(gyro.vector)
        
        //println("\(gyro.vector.x), \(gyro.vector.y), \(gyro.vector.z)")
        
    }
    
    func sendMovementWith(gyroVector : TLMVector3) {
        if gyroVector.z < -200 && !rightHitToggle {
            rightHitToggle = true
            sendMessage("[\"hit\",{\"id\":116599,\"data\":\"yo\"}]")
            counter++
        }
        else if gyroVector.z > -200 && rightHitToggle {
            rightHitToggle = false
        }
    }
    
    func openSocket() {
        ws.event.open = {
            println("open")
        }
        ws.event.close = { (code, reason, clean) in
            println("close")
        }
        ws.event.error = { (error) in
            println("error \(error.localizedDescription)")
        }
        ws.event.message = { (message) in
            if let text = message as? String {
                println("recv: \(text)")
            }
        }
    }
    
    func sendMessage(message : String) {
        println(message)
        ws.send(message)
    }
    
    func refreshGraph(quat : TLMQuaternion) {
        
        xPoints.append(CGFloat(quat.x))
        yPoints.append(CGFloat(quat.y))
        zPoints.append(CGFloat(quat.z))
        wPoints.append(CGFloat(quat.w))
        
        xGraph.reloadGraph()
        yGraph.reloadGraph()
        zGraph.reloadGraph()
        wGraph.reloadGraph()
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 20
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return -1.0
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 1.0
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if graph == xGraph {
            return xPoints[xPoints.count - 20 + index]
        }
        else if graph == yGraph {
            return yPoints[yPoints.count - 20 + index]
        }
        else if graph == wGraph {
            return zPoints[zPoints.count - 20 + index]
        }
        else {
            return wPoints[wPoints.count - 20 + index]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
