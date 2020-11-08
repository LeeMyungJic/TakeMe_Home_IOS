//
//  UpdateStoreViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpdateStoreViewController: UIViewController {
    
    @IBOutlet var addressStr: UITextField!
    @IBOutlet var nameStr: UITextField!
    @IBOutlet var numberStr: UITextField!
    
    var rAddress: String?
    var rName: String?
    var rNumber: String?
    
    var longitude: Double?
    var latitude: Double?
    
    func getInfo() {
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/restaurant/\(ManagerCallViewController.restaurantId)")!) { (data, response, error) in
            
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
//                            self.rAddress = temp["address"] as? String
//                            print(self.rAddress)
//                            self.rName = temp["name"] as? String
//                            print(self.rName)
//                            self.rNumber = temp["number"] as? String
//                            print(self.rNumber)
                            // prepare로 넘기장
//                            self.nameStr.attributedPlaceholder = NSAttributedString(string: temp["name"] as? String ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//                            self.addressStr.attributedPlaceholder = NSAttributedString(string: temp["address"] as? String ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//                            self.numberStr.attributedPlaceholder = NSAttributedString(string: temp["number"] as? String ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                            
                        }
                    }
                    
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
                
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfo()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func search(_ sender: Any) {
        let keyword = addressStr.text
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK d05457ec212e64c5f266ca54ee2728db"
        ]
        
        let parameters: [String: Any] = [
            "query": addressStr.text!,
            "page": 1,
            "size": 15
        ]
        
        AF.request("https://dapi.kakao.com/v2/local/search/address.json", method: .get,
                   parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    print("통신 성공 !!")
                    
                    if let detailsPlace = JSON(value)["documents"].array{
                        for item in detailsPlace{
                            let placeName = item["address_name"].string ?? ""
                            self.longitude = Double(item["x"].string ?? "0.0")
                            self.latitude = Double(item["y"].string ?? "0.0")
                            self.addressStr.text = placeName
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
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
