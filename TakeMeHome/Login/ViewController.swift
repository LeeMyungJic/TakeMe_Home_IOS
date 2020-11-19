//
//  ViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var titleLable: UILabel!
    
    let person = ["점주", "라이더", "사용자"]
    
    @IBOutlet var idStr: UITextField!
    @IBOutlet var passStr: UITextField!
    @IBOutlet var personStr: UITextField!
    
    var loginBool : Bool = false
    var select : String?
    var ident : String?
    var token : String?
    
    func getToken(receivedToken : String) {
        self.token = receivedToken
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            }
            else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.token = result.token
                
            }
        }
        
//        let border = CALayer()
//
//        let width = CGFloat(1.0)
//
//        border.borderColor = UIColor.lightGray.cgColor
//
//        border.frame = CGRect(x: 0, y: personStr
//                                .frame.size.height - width, width:  personStr.frame.size.width, height: personStr.frame.size.height)
//
//
//
//        border.borderWidth = width
//
//        personStr.layer.addSublayer(border)
//
//        personStr.layer.masksToBounds = true
        
        
        
        idStr.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passStr.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        personStr.attributedPlaceholder = NSAttributedString(string: "회원 유형을 선택하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        createPickerView()
        dismissPickerView()
    }
    
    @IBAction func Join(_ sender: Any) {
        let addStore = self.storyboard?.instantiateViewController(withIdentifier: "JoinViewController")
        self.present(addStore!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func Login(_ sender: Any) {
        //, "token":token
        var url = URL(string: "")
        var param = ["email":idStr.text, "password":passStr.text, "token" : token] as [String:Any]
        switch personStr.text {
        case "라이더":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/riders/login")
            select = "Rider"
            ident = "TabBar"
        case "점주":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/owners/login")
            select = "Owner"
            ident = select
        case "사용자":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/customers/login")
            select = "Customer"
            ident = select
        default:
            print()
        }
        if let person = personStr.text, let urlT = url {
            login(param: param, url: urlT, isGet: true, person: person)
            
        }
        else {
            print("가입 유형을 선택하세요")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return person.count
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
    
    func login(param: [String:Any], url: URL, isGet: Bool = false, person: String = "") {
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        var request = URLRequest(url: url)
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
            //print("responseString = \(responseString)")
            if isGet {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                    {
                        
                        if let temp2 = json["data"] as? Int {
                            
                            switch person {
                            case "라이더":
                                CallViewController.riderId = temp2
                            case "사용자":
                                CustomerOrderViewController.userId = temp2
                            case "점주":
                                ManagerViewController.ownerId = temp2
                            default:
                                print("")
                            }
                            self.move()
                        }
                    }
                    
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
                
            }
            
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            
        }
        // POST 전송
        task.resume()
    }
    
    func move() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: self.select!, bundle: nil)
            
            let popUp = storyboard.instantiateViewController(identifier: self.ident!)
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.modalTransitionStyle = .crossDissolve
            
            self.present(popUp, animated: true, completion: nil)
        }
    }
    
}

