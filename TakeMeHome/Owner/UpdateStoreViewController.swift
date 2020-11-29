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
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/restaurant/1")!) { (data, response, error) in
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameStr.attributedPlaceholder = NSAttributedString(string: "이름 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        addressStr.attributedPlaceholder = NSAttributedString(string: "주소 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        numberStr.attributedPlaceholder = NSAttributedString(string: "번호 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        //getInfo()

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
    @IBAction func Update(_ sender: Any) {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/restaurant/" + "\(ManagerCallViewController.restaurantId)")
        let param = ["address": "\(addressStr.text!)", "location": ["x":self.latitude, "y":self.longitude], "name": "\(nameStr.text!)", "number": "\(numberStr.text!)", "ownerId": 1] as [String : Any]
        Put(param: param, url: url!)
        
        guard let moveFirst = tabBarController?.viewControllers?[0] else {
            return
        }
        tabBarController?.selectedViewController = moveFirst
    }
    
}
