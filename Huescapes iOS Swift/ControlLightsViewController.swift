//
//  ControlLightsViewController.swift
//  Huescapes iOS Swift
//

import UIKit

class ControlLightsViewController: UIViewController {
    
  let maxHue = 65535
  
  @IBOutlet var bridgeMacLabel: UILabel?
  @IBOutlet var bridgeIpLabel: UILabel?
  @IBOutlet var bridgeLastHeartbeatLabel: UILabel?
  @IBOutlet var randomLightsButton: UIButton?
    @IBOutlet weak var testbutt: UIButton!
  @IBOutlet weak var scrollView: UIScrollView! //this handles/holds our scenes (their pictures, specifically)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //create reference to first preset image
   // let vc0 = ForestImageViewController(nibName: "ForestImageView", bundle: nil)
    //add it to the scrollView
   // self.addChildViewController(vc0)
   // self.scrollView.addSubview(vc0.view)
   // vc0.didMoveToParentViewController(self)
    
    //create reference to second preset image
   // let vc1 = OceanImageViewController(nibName: "OceanImageView", bundle: nil)
    //make it appear as the first image to the right
  //  var frame1 = vc1.view.frame
   // frame1.origin.x = self.view.frame.size.width //it starts being drawn where the first image ends. Multiply by constant for consecutive screens
   // vc1.view.frame = frame1
    //add it to the scrollView
   // self.addChildViewController(vc1)
   // self.scrollView.addSubview(vc1.view)
   // vc1.didMoveToParentViewController(self)
    
   // self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height)
    
    let notificationManager = PHNotificationManager.defaultManager()
    // Register for the local heartbeat notifications
    notificationManager.registerObject(self, withSelector: "localConnection", forNotification: LOCAL_CONNECTION_NOTIFICATION)
    
    notificationManager.registerObject(self, withSelector: "noLocalConnection", forNotification: NO_LOCAL_CONNECTION_NOTIFICATION)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Find Bridge", style: UIBarButtonItemStyle.Plain, target: self, action: "findNewBridgeButtonAction")
    
    navigationItem.title = "Your Scenes"
    
    noLocalConnection()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func edgesForExtendedLayoutfix() -> UIRectEdge {
    return (UIRectEdge.Left.union(UIRectEdge.Bottom).union(UIRectEdge.Right))
  }
  
  func localConnection() {
    loadConnectedBridgeValues()
  }
  
  func noLocalConnection() {
    bridgeLastHeartbeatLabel?.text = "Not connected"
    bridgeLastHeartbeatLabel?.enabled = false
    bridgeIpLabel?.text = "Not connected"
    bridgeIpLabel?.enabled = false
    bridgeMacLabel?.text = "Not connected"
    bridgeMacLabel?.enabled = false
    
    randomLightsButton?.enabled = false
  }
  
  func loadConnectedBridgeValues() {
    let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
    
    // Check if we have connected to a bridge before
    if cache?.bridgeConfiguration?.ipaddress != nil {
      // Set the ip address of the bridge
      bridgeIpLabel?.text = cache!.bridgeConfiguration!.ipaddress

      // Set the mac adress of the bridge
      bridgeMacLabel?.text = cache!.bridgeConfiguration!.mac

      
      // Check if we are connected to the bridge right now
      let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
      if appDelegate.phHueSdk.localConnected() {

        // Show current time as last successful heartbeat time when we are connected to a bridge
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle
        bridgeLastHeartbeatLabel?.text = dateFormatter.stringFromDate(NSDate())
          
        randomLightsButton?.enabled = true
      } else {
        bridgeLastHeartbeatLabel?.text = "Waiting..."
        randomLightsButton?.enabled = false
      }
    }
  }
  
  @IBAction public func randomizeColoursOfConnectLights(_: AnyObject) {
    randomLightsButton?.enabled = false
    let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
    let bridgeSendAPI = PHBridgeSendAPI()
    
    for light in cache!.lights!.values {
      // don't update state of non-reachable lights
      if light.lightState!.reachable == 0 {
        continue
      }
      
      let lightState = PHLightState()
      
//      if light.type.value == DIM_LIGHT.rawValue {
//        // Lux bulbs just get a random brightness
//        lightState.brightness = Int(arc4random()) % 254
//      } else {
        lightState.hue = Int(arc4random()) % maxHue
     //   lightState.brightness = 254
        lightState.brightness = Int(arc4random()) % 254
        lightState.saturation = 254
//      }
      
      // Send lightstate to light
      bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: lightState, completionHandler: { (errors: [AnyObject]!) -> () in
        
        if errors != nil {
          let message = String(format: NSLocalizedString("Errors %@", comment: ""), errors)
          NSLog("Response: \(message)")
        }
        self.randomLightsButton?.enabled = true
      })
      
    }
  }
  
  func findNewBridgeButtonAction() {
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    appDelegate.searchForBridgeLocal()
  }
    
}
