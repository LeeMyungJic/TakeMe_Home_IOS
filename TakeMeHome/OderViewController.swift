//
//  OderViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/12.
//

import UIKit

class OderViewController: UIViewController {

    @IBOutlet var address: UILabel!
    @IBOutlet var arrivalTime: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var methodOfPayment: UILabel!
    @IBOutlet var requirement: UILabel!
    
    var addressStr = String()
    var arrivalTimeStr = ""
    var priceStr = ""
    var methodOfPaymentStr = ""
    var requirementStr = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        address.text = addressStr
        arrivalTime.text = arrivalTimeStr
        price.text = priceStr
        methodOfPayment.text = methodOfPaymentStr
        requirement.text = requirementStr
    }
    
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
