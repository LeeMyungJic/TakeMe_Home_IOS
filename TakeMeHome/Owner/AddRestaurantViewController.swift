//
//  AddRestaurantViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddRestaurantViewController: UIViewController {

    @IBOutlet var addressStr: UITextField!
    @IBOutlet var StoreName: UITextField!
    @IBOutlet var Number: UITextField!
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressStr.attributedPlaceholder = NSAttributedString(string: "주소를 검색하세요 (ex : 인주대로 857)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        StoreName.attributedPlaceholder = NSAttributedString(string: "가게 이름을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        Number.attributedPlaceholder = NSAttributedString(string: "번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchAddress(_ sender: Any) {
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
    @IBAction func addButton(_ sender: Any) {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/restaurants")
        let param = ["address": "\(addressStr.text!)", "location": ["x":self.latitude, "y":self.longitude], "name": "\(StoreName.text!)", "number": "\(Number.text!)", "ownerId": 1] as [String : Any]
        Post(param: param, url: url!)
        
        let storyboard = UIStoryboard.init(name: "Manager", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "ManagerViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        self.present(popUp, animated: true, completion: nil)
        
        
    }
    
}
