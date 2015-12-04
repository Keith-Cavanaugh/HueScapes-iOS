//
//  CustomViewController.swift
//  Huescapes iOS Swift
//
//  Created by John Wrobel on 12/1/15.
//

import UIKit



class AboutView : UIViewController {
    
    var lightTimer = NSTimer()
    
    override func viewDidLoad() {
        lightTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("pulseColor"), userInfo: nil, repeats: true)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lightTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var changeDirection = 0
    
    @IBAction func pulseColor() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        let bridgeSendAPI = PHBridgeSendAPI()
        
        for light in cache!.lights!.values {
            
            // don't update state of non-reachable lights
            if light.lightState!.reachable == 0 {
                continue
            }
            
            let lightState = PHLightState()
            
            lightState.transitionTime = 30
            lightState.hue = Int(arc4random_uniform(65535))
            lightState.saturation = 254
            
            if(changeDirection == 0) {
                lightState.brightnessIncrement = 100
            } else {
                lightState.brightnessIncrement = -100
            }
            
            // Send lightstate to light
            bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: lightState, completionHandler: { (errors: [AnyObject]!) -> () in
                
                if errors != nil {
                    let message = String(format: NSLocalizedString("Errors %@", comment: ""), errors)
                    NSLog("Response: \(message)")
                }
            })
            
        }
        
        if(changeDirection == 0) {
            changeDirection = 1
        } else {
            changeDirection = 0
        }
    }
}