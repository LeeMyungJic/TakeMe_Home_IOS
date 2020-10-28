//
//  ViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var passStr: UITextField!
    @IBOutlet var idStr: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idStr.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passStr.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        /*
        UserDefaults.standard.set(self.idStr, forKey: "id")
        UserDefaults.standard.set(self.passStr, forKey: "pwd")
        
        if let userId = UserDefaults.standard.string(forKey: "id"){
            self.idStr.text = userId
            self.passStr.text = UserDefaults.standard.string(forKey: "pwd")!
        }
        */
    }
    
    @IBAction func Login(_ sender: Any) {
        
        guard let id = idStr.text, !id.isEmpty else { return }
                guard let password = passStr.text, !password.isEmpty else { return }
                
                // Model이 해당 유저를 가지고 있는지 검사
                var loginSuccess: Bool = false
        
        if idStr.text == id, passStr.text == password {
            loginSuccess = true
        }
        
        if loginSuccess {
            print("로그인 성공")
            guard let main = self.storyboard?.instantiateViewController(identifier: "TabBar") else{return}
            self.present(main, animated: true)
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.idStr.frame.origin.x -= 10
                self.passStr.frame.origin.x -= 10
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.idStr.frame.origin.x += 20
                    self.passStr.frame.origin.x += 20
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.idStr.frame.origin.x -= 10
                        self.passStr.frame.origin.x -= 10
                    })
                })
            })
        }
    }
}

