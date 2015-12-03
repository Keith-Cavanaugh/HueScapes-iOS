import UIKit

class LavaViewPicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        //    useCameraRoll(self)
    }
    
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        var photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
}
