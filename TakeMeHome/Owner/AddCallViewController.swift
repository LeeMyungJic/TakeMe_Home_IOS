//
//  AddCallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import UIKit

class AddCallViewController: UIViewController {

    
    @IBOutlet var nameStr: UITextField!
    @IBOutlet var priceStr: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        nameStr.attributedPlaceholder = NSAttributedString(string: "상품명을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        priceStr.attributedPlaceholder = NSAttributedString(string: "가격을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    @IBAction func addButton(_ sender: Any) {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/menus")
        let param = (["name" : nameStr.text!, "price" : Int(priceStr.text!), "restaurantId" : ManagerCallViewController.restaurantId] as? [String:Any])!
        Post(param: param, url: url!)
        
        printError(code: 1)
        
        guard let moveFirst = tabBarController?.viewControllers?[2] else {
            return
        }
        tabBarController?.selectedViewController = moveFirst
    }
    
    func printError(code: Int) {
        
        let msg = UIAlertController(title: "", message: "메뉴를 등록하였습니다", preferredStyle: .alert)
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
        })
        //Alert에 이벤트 연결
        msg.addAction(YES)
        //Alert 호출
        nameStr.text = ""
        priceStr.text = ""
        self.present(msg, animated: true, completion: nil)
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
