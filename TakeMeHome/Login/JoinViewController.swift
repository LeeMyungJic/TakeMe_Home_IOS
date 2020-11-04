//
//  JoinViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/28.
//

import UIKit
import Alamofire
import SwiftyJSON

class JoinViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    let person = ["Manager", "Rider", "User"]
    
    let pickerView = UIPickerView()
    
    var latitude: Double?
    var longitude: Double?
    
    @IBOutlet var emailStr: UITextField!
    @IBOutlet var nameStr: UITextField!
    @IBOutlet var passStr: UITextField!
    @IBOutlet var addressStr: UITextField!
    @IBOutlet var phoneStr: UITextField!
    @IBOutlet var passChkStr: UITextField!
    @IBOutlet var personStr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        dismissPickerView()
        
        nameStr.attributedPlaceholder = NSAttributedString(string: "이름을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        emailStr.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passStr.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passChkStr.attributedPlaceholder = NSAttributedString(string: "비밀번호를 한 번 더 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        phoneStr.attributedPlaceholder = NSAttributedString(string: "비밀번호를 한 번 더 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        addressStr.attributedPlaceholder = NSAttributedString(string: "주소를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        personStr.attributedPlaceholder = NSAttributedString(string: "가입자 유형을 선택하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
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
                            self.addressStr.text = placeName
                            //self.longitude = longitudeX
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return person.count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return person[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        personStr.text = person[row]
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        personStr.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(ButtonAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        personStr.inputAccessoryView = toolBar
    }
    
    @objc func ButtonAction() {
        
        // 피커뷰 내리기
        personStr.resignFirstResponder()
    }
    @IBAction func join(_ sender: Any) {
        
        //        let urlPath = "http://localhost:8080/api/v1/customers"
        //        let url = NSURL(string: urlPath)
        //
        //        let session = URLSession.shared
        //
        //        let task = session.dataTask(with: url! as URL) { (data, response, error) in
        //            if error == nil {
        //                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        //                print(urlContent ?? "No contents")
        //            }
        //            else {
        //                print("error occurred")
        //            }
        //        }
        //        task.resume()
        
        
        
        
        
        //"address": "addressStr.text","location" : 0,
        
        let param = ["email": "\(emailStr.text!)", "name": "\(nameStr.text!)", "password": "\(passStr.text!)", "phoneNumber": "\(phoneStr.text!)"]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        let url = URL(string: "http://e38122c2f521.ngrok.io/api/v1/riders");
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // 4. HTTP 메시지에 포함될 헤더 설정
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
           
        }
        // POST 전송
        task.resume()
        
        
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
struct UserData: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}

struct PostUserData: Codable {
    let userId: String
    let id: Int?
    let title: String
    let body: String
    init(id: Int? = nil) {
        self.userId = "1"
        self.title = "Title"
        self.body = "Body"
        self.id = id }
    func toUserData() -> UserData {
        return UserData(userId: Int(userId) ?? 0, id: id ?? 0, title: title, body: body)
        
    }
    
}

