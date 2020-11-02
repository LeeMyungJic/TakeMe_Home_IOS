//
//  RequestViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class AcceptanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var AcceptanceView: UITableView!
    static var isChange = false
    
    static var acceptanceCalls = [Order]()
    
    var selectedIndex: Int?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "OderView", bundle: nil)
        
        selectedIndex = indexPath.row
        
        let popUp = storyboard.instantiateViewController(identifier: "OderViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? OderViewController
        temp?.addressStr = "주소 값"
        temp?.arrivalTimeStr = "도착시간 값"
        
        
        temp?.addressStr = AcceptanceViewController.acceptanceCalls[selectedIndex!].storeAddress!
        temp?.arrivalTimeStr = AcceptanceViewController.acceptanceCalls[selectedIndex!].arrivalTime!
        temp?.methodOfPaymentStr = AcceptanceViewController.acceptanceCalls[selectedIndex!].methodOfPayment!
        temp?.priceStr = "\(AcceptanceViewController.acceptanceCalls[selectedIndex!].price!) 원"
        temp?.requirementStr = AcceptanceViewController.acceptanceCalls[selectedIndex!].requirement!
        
        
        
        
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AcceptanceViewController.acceptanceCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AcceptanceView.dequeueReusableCell(withIdentifier: "AcceptanceCell", for: indexPath) as! AcceptanceCell
        cell.nameStr.text = AcceptanceViewController.acceptanceCalls[indexPath.row].storeName
        cell.addressStr.text = AcceptanceViewController.acceptanceCalls[indexPath.row].storeAddress
        cell.Time.text = AcceptanceViewController.acceptanceCalls[indexPath.row].cookingTime! + " 까지 조리 완료"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) as! AcceptanceCell
            cell.stack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AcceptanceView.dataSource = self
        AcceptanceView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    // Call에서 수락한 아이템 최신화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AcceptanceViewController.isChange) {
            AcceptanceView.beginUpdates()
            for i in 0...CallViewController.addCount - 1{
                AcceptanceView.insertRows(at: [IndexPath(row: AcceptanceViewController.acceptanceCalls.count - CallViewController.addCount, section: 0)], with: .automatic)
                CallViewController.addCount = CallViewController.addCount - 1
            }
            AcceptanceView.endUpdates()
            AcceptanceViewController.isChange = false
        }
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
