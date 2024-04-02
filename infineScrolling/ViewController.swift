import UIKit

class ViewController: UIViewController, CustomViewDelegate {

    
    
    @IBOutlet weak var customView: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.delegate = self
        print("Controller awakens")

     //   customView.data = [1,2,4,5]
    }
    
    //MARK: - Delegation methods
   
    func setCellData() -> [Any] {
        return [1,2,4]
    }
    
    func setScrollSpeed() -> Double {
        return 0.7
    }
    
    func setWidth() -> Double {
        return 100
    }
    
    func setHeight() -> Double {
        return 30
    }
//    func AutoScrolling() -> Bool {
//        return true
//    }
    
 
}
