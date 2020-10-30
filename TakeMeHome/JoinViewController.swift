//
//  JoinViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/28.
//

import UIKit
import Alamofire
import SwiftyJSON

class JoinViewController: UIViewController {

    @IBOutlet var x: UILabel!
    @IBOutlet var y: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var addressStr: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        addressStr.attributedPlaceholder = NSAttributedString(string: "주소를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
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
                    
                    print(response.result)
                    print("total_count : \(JSON(value)["meta"]["total_count"])")
                    print("is_end : \(JSON(value)["meta"]["is_end"])")
                    print("documents : \(JSON(value)["documents"])")
                    
                    
                    if let detailsPlace = JSON(value)["documents"].array{
                        for item in detailsPlace{
                            let placeName = item["address_name"].string ?? ""
                            let longitudeX = item["x"].string ?? ""
                            let latitudeY = item["y"].string ?? ""
                            self.x.text = "x좌표 : " + latitudeY
                            self.y.text = "y좌표 : " + longitudeX
                            self.name.text = "주소 : " + placeName
                        }
                        
                    }
                //print("\(self.resultList[0].placeName)")
                //print("\(self.resultList[0].longitudeX)")
                //print("\(self.resultList[0].latitudeY)")
                
                case .failure(let error):
                    print(error)
                }
            })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

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
