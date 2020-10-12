//
//  CallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class CallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempIndex:IndexPath? = nil
    static var addCount = 0
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CallItem.callItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        cell.storeNameStr.text = CallItem.callItems[indexPath.row].storeName
        cell.storeAddress.text = CallItem.callItems[indexPath.row].address
        cell.timeStr.text = CallItem.callItems[indexPath.row].cookingTime! + " 까지 조리 완료"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = UIAlertController(title: CallItem.callItems[indexPath.row].storeName, message: "접수하시겠습니까?", preferredStyle: .alert)
        
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.YesClick(didSelectRowAt: indexPath)
        })
        
        //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "취소", style: .cancel) { (action) -> Void in
            self.NoClick()
        }
        
        //Alert에 이벤트 연결
        msg.addAction(YES)
        msg.addAction(NO)
        
        //Alert 호출
        self.present(msg, animated: true, completion: nil)
    }
    
    func YesClick(didSelectRowAt indexPath: IndexPath)
    {
        print("YES Click")
        let temp = AcceptanceItem(address: CallItem.callItems[indexPath.row].address!, storeName: CallItem.callItems[indexPath.row].storeName!, latitude: CallItem.callItems[indexPath.row].latitude!, longitude: CallItem.callItems[indexPath.row].longitude!, cookingTime: CallItem.callItems[indexPath.row].cookingTime!)
        CallItem.callItems.remove(at: indexPath.row)
        AcceptanceItem.acceptanceItems.append(temp)
        TableViewMain.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        AcceptanceViewController.isChange = true
        CallViewController.addCount = CallViewController.addCount + 1
        print("에드 카운트")
        print(CallViewController.addCount)
        print("acceptanceItems count")
        print(AcceptanceItem.acceptanceItems.count)
        
    }
    
    func NoClick()
    {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        print("DidLoad")
        
        
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
