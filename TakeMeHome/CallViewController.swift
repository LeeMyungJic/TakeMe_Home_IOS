//
//  CallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class CallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempIndex:IndexPath? = nil
    var itemData:Array<Dictionary<String, Any>>?
    
    var mTimer:Timer?
    static var addCount = 0
    var count = 0
    let interval = 2.0
    let timeSelector: Selector = #selector(CallViewController.timerCallback)
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    // Call 아이템 가져오기
    func getItems() {
        let task = URLSession.shared.dataTask(with: URL(string : "")!) { (data, response, error) in
            if let dataJson = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    
                    let receivedItems = json["item 이름"] as! Array<Dictionary<String, Any>>
                    
                    self.TableViewMain.reloadData()
                }
                
                catch {
                    
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CallItem.callItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = TableViewMain.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        
        /*
         let inx = indexPath.row
         if let receivedItem = itemData {
         let row = receivedItem[indexPath.row]
         if let r = row as? Dictionary<String, Any> {
         // 아이템 각 항목이 있으면 넣어주기
         if let address = r["address"] as? String, let storeName = r["storeName"] as? String, let cookingTime = r["cookingTime"] as? String, let latitude = r["latitude"] as? String, let longitude = r["longitude"] as? String, let oderCode = r["oderCode"] as? String {
         
         cell.storeNameStr.text = storeName
         cell.storeAddress.text = address
         cell.timeStr.text = cookingTime
         
         }
         }
         }
         */
        
        
        cell.storeNameStr.text = CallItem.callItems[indexPath.row].storeName
        cell.storeAddress.text = CallItem.callItems[indexPath.row].address
        cell.timeStr.text = CallItem.callItems[indexPath.row].cookingTime! + " 까지 조리 완료"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        // 빈 셀 출력 x
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) as! CallCell
            cell.stack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
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
        let temp = AcceptanceItem(address: CallItem.callItems[indexPath.row].address!, storeName: CallItem.callItems[indexPath.row].storeName!, latitude: CallItem.callItems[indexPath.row].latitude!, longitude: CallItem.callItems[indexPath.row].longitude!, cookingTime: CallItem.callItems[indexPath.row].cookingTime!, oderCode: CallItem.callItems[indexPath.row].oderCode!)
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
        
//        if let timer = mTimer {
//            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
//            if !timer.isValid {
//                /** 1초마다 timerCallback함수를 호출하는 타이머 */
//                mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
//            }
//        }else{
//            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
//            /** 1초마다 timerCallback함수를 호출하는 타이머 */
//            mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
//        }
        
    }
    
    @objc func timerCallback() {
        
        print("타임 콜백 !!")
        
        TableViewMain.beginUpdates()
        CallItem.callItems.append(CallItem(address: "인천광역시 남동구 만수동", storeName: "한신포차 만수점", latitude: 37.44923885384186, longitude: 126.73117584962965, cookingTime: "12:42", odercode: "T24A"))
        TableViewMain.insertRows(at: [IndexPath(row: CallItem.callItems.count - 1, section: 0)], with: .automatic)
        TableViewMain.endUpdates()
    }
}



