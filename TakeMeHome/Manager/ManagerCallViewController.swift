//
//  ManagerCallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import UIKit

class ManagerCallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var TableViewMain: UITableView!
    
    var callList = [Order]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        callList = [Order]()
        for item in Order.Orders {
            if StoreName.text == item.storeName {
                callList.append(item)
            }
        }
        return callList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "OderView", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "OderViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? OderViewController
        temp?.addressStr = "주소 값"
        temp?.arrivalTimeStr = "도착시간 값"
        
        
        temp?.addressStr = callList[indexPath.row].storeAddress!
        temp?.arrivalTimeStr = callList[indexPath.row].arrivalTime!
        temp?.methodOfPaymentStr = callList[indexPath.row].methodOfPayment!
        temp?.priceStr = "\(callList[indexPath.row].price!) 원"
        temp?.requirementStr = callList[indexPath.row].requirement!
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableViewMain.dequeueReusableCell(withIdentifier: "ManagerCallCell", for: indexPath) as! ManagerCallCell
        
        
        cell.storeName.text = callList[indexPath.row].storeName
        cell.destinationAddress.text = callList[indexPath.row].destinationAddress
        cell.cookingTime.text = "\(callList[indexPath.row].cookingTime!)까지 조리 완료"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        // 빈 셀 출력 x
//        else {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) as! ManagerCallCell
//            cell.stack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
        
        return cell
    }
    

    static var getStoreName = "NULL"
    @IBOutlet var StoreName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreName.text = ManagerCallViewController.getStoreName

        TableViewMain.delegate = self
        TableViewMain.dataSource = self
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
