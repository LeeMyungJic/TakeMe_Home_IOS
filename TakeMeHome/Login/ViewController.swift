//
//  ViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let person = ["점주", "라이더", "사용자"]
    
    @IBOutlet var idStr: UITextField!
    @IBOutlet var passStr: UITextField!
    @IBOutlet var personStr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        border.borderColor = UIColor.lightGray.cgColor
        
        border.frame = CGRect(x: 0, y: personStr
                                .frame.size.height - width, width:  personStr.frame.size.width, height: personStr.frame.size.height)
        
        
        
        border.borderWidth = width
        
        personStr.layer.addSublayer(border)
        
        personStr.layer.masksToBounds = true
        
        
        
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
        
        //        var url = URL(string: "")
        //        var param = ["email":idStr.text, "password":passStr.text] as [String:Any]
        //        switch personStr.text {
        //        case "라이더":
        //            url = URL(string: NetWorkController.baseUrl + "/api/v1/riders/login")
        //        case "점주":
        //            url = URL(string: NetWorkController.baseUrl + "/api/v1/owners/login")
        //        case "사용자":
        //            url = URL(string: NetWorkController.baseUrl + "/api/v1/customers/login")
        //        default:
        //           print()
        //        }
        //
        //
        //        Post(param: param, url: url!)
        
        //        guard let id = idStr.text, !id.isEmpty else { return }
        //                guard let password = passStr.text, !password.isEmpty else { return }
        //
        //                // Model이 해당 유저를 가지고 있는지 검사
        //                var loginSuccess: Bool = false
        //
        //        if idStr.text == id, passStr.text == password {
        //            loginSuccess = true
        //        }
        //
        //        if loginSuccess {
        //            print("로그인 성공")
        //            guard let main = self.storyboard?.instantiateViewController(identifier: "TabBar") else{return}
        //            self.present(main, animated: true)
        //        }else {
        //            UIView.animate(withDuration: 0.2, animations: {
        //                self.idStr.frame.origin.x -= 10
        //                self.passStr.frame.origin.x -= 10
        //            }, completion: { _ in
        //                UIView.animate(withDuration: 0.2, animations: {
        //                    self.idStr.frame.origin.x += 20
        //                    self.passStr.frame.origin.x += 20
        //                }, completion: { _ in
        //                    UIView.animate(withDuration: 0.2, animations: {
        //                        self.idStr.frame.origin.x -= 10
        //                        self.passStr.frame.origin.x -= 10
        //                    })
        //                })
        //            })
        //        }
        if(idStr.text == "a") {
            let storyboard = UIStoryboard.init(name: "Manager", bundle: nil)
            
            let popUp = storyboard.instantiateViewController(identifier: "ManagerViewController")
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.modalTransitionStyle = .crossDissolve
            
            self.present(popUp, animated: true, completion: nil)
        }
        else {
            let storyboard = UIStoryboard.init(name: "Rider", bundle: nil)
            
            let popUp = storyboard.instantiateViewController(identifier: "TabBar")
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.modalTransitionStyle = .crossDissolve
            
            self.present(popUp, animated: true, completion: nil)
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
}

