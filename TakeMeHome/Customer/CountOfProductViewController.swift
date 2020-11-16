//
//  CountOfProductViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/12.
//

import UIKit

class CountOfProductViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var completionHandler: ((Int) -> (Int))?
    
    var nameStr:String?
    var productPrice : Int?
    var totalPrice = 0
    var totalCount = 0
    var menuId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let sb = storyboard?.instantiateViewController(identifier: "StoreDetailViewController") else {
            return
        }
        
        let temp = sb as? StoreDetailViewController
        
        temp?.completionHandler = {
            print("컴플리션핸들러 오더")
        }
        guard let p = productPrice else {
            return
        }
        guard let n = nameStr else {
            return
        }
        guard let menu = menuId else {
            return
        }
        name.text = n
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 11
        // Do any additional setup after loading the view.
    }
    @IBAction func addOrMinus(_ sender: UIStepper) {
        countLabel.text = Int(sender.value).description + " 개"
        price.text = "\(Int(sender.value) * productPrice!) 원"
        totalPrice = Int(sender.value) * productPrice!
    }
    
    @IBAction func ok(_ sender: Any) {
        totalCount = Int(stepper.value)
        if totalCount != 0 {
            _ = completionHandler?(self.totalPrice)
            LastOrderViewController.menuList.append(menuAndCount(count: totalCount, name: nameStr!, menuId: menuId!))
            LastOrderViewController.price.append(productPrice!)
            print(LastOrderViewController.menuList.count)
            print(LastOrderViewController.price.count)
        }
        
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
