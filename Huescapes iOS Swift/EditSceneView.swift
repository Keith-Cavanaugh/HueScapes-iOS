import UIKit

class EditSceneView: UIViewController, UIApplicationDelegate {
    
    let phHueSdk: PHHueSDK = PHHueSDK()
    var window: UIWindow?
    var noConnectionAlert: UIAlertController?
    var noBridgeFoundAlert: UIAlertController?
    var authenticationFailedAlert: UIAlertController?
    var loadingView: LoadingViewController?
    
    

     func showLoadingViewWithText(text:String) {
        

        
        // First remove
        removeLoadingView()
        
        // Then add new
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loadingView = storyboard.instantiateViewControllerWithIdentifier("Loading") as? LoadingViewController

        loadingView!.view.frame = navigationController!.view.bounds
        navigationController?.view.addSubview(loadingView!.view)
        loadingView!.loadingLabel?.text = text
    }
    
    /// Removes the full screen loading overlay.
    func removeLoadingView() {
        loadingView?.view.removeFromSuperview()
        loadingView = nil
    }
    
    override func viewDidLoad() {
      //  showLoadingViewWithText(NSLocalizedString("Analyzing", comment: "Generating Local Color Clusters"))
    }

}
