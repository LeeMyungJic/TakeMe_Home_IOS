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

       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = getName
        priceLabel.text = "\(getPrice)"
        guard let temp = ChangeStatusViewController.menuId else {
            return
        }
        
        _ = completionHandler?()
    }
    
    @IBAction func sale(_ sender: Any) {
        url = URL(string: NetWorkController.baseUrl + "/api/v1/menus/menu/" + "\(ChangeStatusViewController.menuId!)")
        let param = ["menuStatus": "SALE", "name" : nameLabel.text!, "price" : priceLabel.text!] as? [String : Any]
        Put(param: param!, url: url!)
        guard let temp1 = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
            return
        }
        temp1.completionHandler = {
            
        }
        printState(code: 1)
    }
    @IBAction func soldOut(_ sender: Any) {
        url = URL(string: NetWorkController.baseUrl + "/api/v1/menus/menu/" + "\(ChangeStatusViewController.menuId!)")
        let param = ["menuStatus": "SOLDOUT", "name" : nameLabel.text!, "price" : priceLabel.text!] as? [String : Any]
        Put(param: param!, url: url!)
        
        guard let temp1 = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
            return
        }
        temp1.completionHandler = {
            
        }
        printState(code: 1)
        
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        url = URL(string: NetWorkController.baseUrl + "/api/v1/menus/menu/" + "\(ChangeStatusViewController.menuId!)")
        let param = [:] as? [String : Any]
        Delete(param: param!, url: url!)
        
        guard let temp1 = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
            return
        }
        temp1.completionHandler = {
            
        }
        printState(code: 2)
    }
    
    func printState(code: Int) {
        let msg : UIAlertController?
        if(code == 1) {
            msg = UIAlertController(title: "", message: "상품을 수정였습니다", preferredStyle: .alert)
        }
        else {
            msg = UIAlertController(title: "", message: "상품을 삭제하였습니다", preferredStyle: .alert)
        }
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.YesClick()
        })
        
        //Alert에 이벤트 연결
        msg!.addAction(YES)
        
        //Alert 호출
        self.present(msg!, animated: true, completion: nil)
    }
    
    func YesClick() {
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
