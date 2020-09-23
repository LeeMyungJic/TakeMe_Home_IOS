import UIKit
 
class ViewAlertFavoriteAdd: UIView {
 
    // Outlet
    @IBOutlet weak var et_itemTitle: UITextField!
    @IBOutlet weak var et_itemPrice: UITextField!
    @IBOutlet weak var et_itemDescription: UITextField!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    
    // identifier
    class var identifier: String
    {
        return String.className(self)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: self.identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    // MARK : btnAction
    @IBAction func btnClick_add(_ sender: UIButton) {
        
        NSLog("===== ViewAlertFavoriteAdd btnClick_add =====");
    }
    
    @IBAction func btnClick_Close(_ sender: UIButton) {
        
        NSLog("===== ViewAlertFavoriteAdd btnClick_Close =====");
        
        removeFromSuperview();
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
 
}
 


출처: https://eteris.tistory.com/1722 [Eteris's Palace]
