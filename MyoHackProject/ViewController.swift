//
//  ViewController.swift
//  MyoHackProject
//
//  Created by ISMAIL J MUSTAFA on 7/11/15.
//  Copyright (c) 2015 MyoHack. All rights reserved.
//

import UIKit

var myoIdentifier : NSUUID = NSUUID(UUIDString: "0A66A6EA-D5D1-F872-E701-49AD2FFC45E4")!

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TLMHub.sharedHub().attachByIdentifier(myoIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        var orientation = notification.userInfo![kTLMKeyOrientationEvent]! as! TLMOrientationEvent
        
        
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


}
