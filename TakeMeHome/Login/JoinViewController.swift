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
    
    let person = ["점주", "라이더", "사용자"]
    
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
        
        emailStr.attributedPlaceholder = NSAttributedString(string: "example@naver.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passStr.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passChkStr.attributedPlaceholder = NSAttributedString(string: "비밀번호를 한 번 더 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        phoneStr.attributedPlaceholder = NSAttributedString(string: "휴대폰 번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        addressStr.attributedPlaceholder = NSAttributedString(string: "주소 검색(ex : 인주대로 857)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
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
        
        var param: [String:Any] = ["":""]
        var url = URL(string: NetWorkController.baseUrl + "http://localhost:8080/api/v1/customers");
        //"address": "addressStr.text","location" : 0,
        switch personStr.text {
        case "사용자":
            print("User 선택")
            url = URL(string: NetWorkController.baseUrl + "/api/v1/riders")
            param = ["address": "\(addressStr.text!)", "email": "\(emailStr.text!)", "location": ["x":self.latitude, "y":self.longitude], "name": "\(nameStr.text!)", "password": "\(passStr.text!)", "phoneNumber": "\(phoneStr.text!)"]
        case "라이더":
            print("Rider 선택")
            url = URL(string: NetWorkController.baseUrl + "/api/v1/riders")
            param = ["email": "\(emailStr.text!)", "name": "\(nameStr.text!)", "password": "\(passStr.text!)", "phoneNumber": "\(phoneStr.text!)"]
        case "점주":
            print("Manager 선택")
            url = URL(string: NetWorkController.baseUrl + "/api/v1/owners")
            param = ["address": "\(addressStr.text!)", "email": "\(emailStr.text!)", "location": ["x":self.latitude, "y":self.longitude], "name": "\(nameStr.text!)", "password": "\(passStr.text!)", "phoneNumber": "\(phoneStr.text!)"]
        default:
            print("")
        }
        Post(param: param, url: url!)
        self.dismiss(animated: true, completion: nil)
        
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

