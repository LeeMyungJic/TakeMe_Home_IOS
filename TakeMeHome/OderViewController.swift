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
    var orderId = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()

        address.text = addressStr
        arrivalTime.text = arrivalTimeStr
        price.text = priceStr
        methodOfPayment.text = methodOfPaymentStr
        requirement.text = requirementStr
        print("\(orderId) ====================================")
    }
    
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func complete(_ sender: Any) {
        let msg = UIAlertController(title: "배달 확인", message: "배달을 완료하셨습니까?", preferredStyle: .alert)
        
        let YES = UIAlertAction(title: "네", style: .default, handler: { (action) -> Void in
            
            self.YesClick(code: 1)
        })
        
        //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "아니요", style: .cancel) { (action) -> Void in
            self.NoClick()
        }
        
        //Alert에 이벤트 연결
        msg.addAction(YES)
        msg.addAction(NO)
        
        //Alert 호출
        self.present(msg, animated: true, completion: nil)
    }
    
    @IBAction func delivery(_ sender: Any) {
        let msg = UIAlertController(title: "배달 확인", message: "배달을 시작하셨습니까?", preferredStyle: .alert)
        
        let YES = UIAlertAction(title: "네", style: .default, handler: { (action) -> Void in
            
            self.YesClick(code: 2)
        })
        
        //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "아니요", style: .cancel) { (action) -> Void in
            self.NoClick()
        }
        
        //Alert에 이벤트 연결
        msg.addAction(YES)
        msg.addAction(NO)
        
        //Alert 호출
        self.present(msg, animated: true, completion: nil)
    }
    func YesClick(code: Int)
    {
        var url = URL(string : "")
        if code == 1 {
            url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/order/" + "\(orderId)" + "/complete/")
        }
        else {
            url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/order/" + "\(orderId)" + "/pickup/")
        }
        let param = [:] as? [String:Any]
        Put(param: param!, url: url!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func NoClick()
    {
        
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
