//
//  ChangeStatusViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/16.
//

import UIKit

class ChangeStatusViewController: UIViewController {

    var url : URL?
    static var menuId : Int?
    
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var priceLabel: UITextField!
    
    var getName = ""
    var getPrice = 0
    var completionHandler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = getName
        priceLabel.text = "\(getPrice)"
        guard let temp = ChangeStatusViewController.menuId else {
            return
        }
        
        _ = completionHandler?()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sale(_ sender: Any) {
        url = URL(string: NetWorkController.baseUrl + "/api/v1/menus/menu/" + "\(ChangeStatusViewController.menuId!)" + "/sale")
        let param = [:] as? [String : Any]
        Put(param: param!, url: url!)
        guard let temp1 = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
            return
        }
        temp1.completionHandler = {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func soldOut(_ sender: Any) {
        url = URL(string: NetWorkController.baseUrl + "/api/v1/menus/menu/" + "\(ChangeStatusViewController.menuId!)" + "/soldout")
        let param = [:] as? [String : Any]
        Put(param: param!, url: url!)
        
        guard let temp1 = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
            return
        }
        temp1.completionHandler = {
            
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
