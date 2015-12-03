//
//  CustomViewController.swift
//  Huescapes iOS Swift
//
//  Created by John Wrobel on 12/1/15.
//

import UIKit



class CustomViewController: UIViewController {
    
    var resetTimer = NSTimer()
    var lightTimer = NSTimer()
    var bulbToOperateOn = 0
    
    override func viewDidLoad() {
        initializeLights()
        lightTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("changeColor"), userInfo: nil, repeats: true)
        resetTimer = NSTimer.scheduledTimerWithTimeInterval(12.0, target: self, selector: Selector("initializeLights"), userInfo: nil, repeats: true)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lightTimer.invalidate()
        resetTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeLights() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        let bridgeSendAPI = PHBridgeSendAPI()
        
        for light in cache!.lights!.values {
            // don't update state of non-reachable lights
            if light.lightState!.reachable == 0 {
                continue
            }
            
            let lightState = PHLightState()
            
            lightState.transitionTime = 30
            lightState.brightness = Int(arc4random()) % 254
            lightState.saturation = 254
            
            if(bulbToOperateOn == 0) {
                lightState.hue = 7000
                bulbToOperateOn = 1
            } else {
                lightState.hue = 40000
                bulbToOperateOn = 0
            }
            
            // Send lightstate to light
            bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: lightState, completionHandler: { (errors: [AnyObject]!) -> () in
                
                if errors != nil {
                    let message = String(format: NSLocalizedString("Errors %@", comment: ""), errors)
                    NSLog("Response: \(message)")
                }
            })
            
        }
    }
    
    @IBAction func changeColor() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        let bridgeSendAPI = PHBridgeSendAPI()
        
        for light in cache!.lights!.values {
            // don't update state of non-reachable lights
            if light.lightState!.reachable == 0 {
                continue
            }
            
            let incOrDec = Int(arc4random_uniform(10))
            
            let lightState = PHLightState()
            
            lightState.transitionTime = 30
            
            lightState.brightness = Int(arc4random()) % 254
            //lightState.hue = 25500
            //lightState.saturation = 254
            
            if(incOrDec < 5) {
                let brightnessIncrementValue = Int(arc4random_uniform(90)) + 150
                let hueIncrementValue = Int(arc4random_uniform(500)) + 500
                lightState.brightnessIncrement = brightnessIncrementValue
                lightState.hueIncrement = hueIncrementValue
            } else {
                let brightnessDecrementValue = (Int(arc4random_uniform(90)) + 150) * -1
                let hueDecrementValue = (Int(arc4random_uniform(500)) + 500) * -1
                lightState.brightnessIncrement = brightnessDecrementValue
                lightState.hueIncrement = hueDecrementValue
            }
            
            // Send lightstate to light
            bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: lightState, completionHandler: { (errors: [AnyObject]!) -> () in
                
                if errors != nil {
                    let message = String(format: NSLocalizedString("Errors %@", comment: ""), errors)
                    NSLog("Response: \(message)")
                }
            })
            
        }
    }
}