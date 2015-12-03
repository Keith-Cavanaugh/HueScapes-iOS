//
//  ForestImageViewController.swift
//  Huescapes iOS Swift
//
//  Created by John Wrobel on 10/17/15.
//

import UIKit
import Foundation

class ForestView: UIViewController {
    
    var greenTimer = NSTimer()
    
    override func viewDidLoad() {
        makeGreen()
        greenTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("makeGreen"), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        greenTimer.invalidate()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func makeGreen() {
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
                let brightnessIncrementValue = Int(arc4random_uniform(50)) + 150
                let saturationIncrementValue = Int(arc4random_uniform(50)) + 25
                let hueIncrementValue = Int(arc4random_uniform(1000)) + 1000
                lightState.brightnessIncrement = brightnessIncrementValue
                lightState.saturationIncrement = saturationIncrementValue
                lightState.hue = 25500 + hueIncrementValue
            } else {
                let brightnessDecrementValue = (Int(arc4random_uniform(50)) + 150) * -1
                let saturationDecrementValue = (Int(arc4random_uniform(50)) + 25) * -1
                let hueDecrementValue = (Int(arc4random_uniform(1000)) + 1000) * -1
                lightState.brightnessIncrement = brightnessDecrementValue
                lightState.saturationIncrement = saturationDecrementValue
                lightState.hue = 25500 + hueDecrementValue
            }
            //lightState.brightness = Int(arc4random()) % 254
            //lightState.hue = 25500
            
            //lightState.saturation = 254
            
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
