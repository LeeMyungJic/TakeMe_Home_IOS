//
//  OrderListViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/13.
//

import UIKit

class OrderListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
                // 비슷한 메서드 주의 : btn.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = submitBtn
//        let more = UIButton(type: .system)
//              more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
//              more.setImage(UIImage(named: "more"), for: .normal)
//              rightSideView.addSubview(more)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_keyboard_arrow_left_2x"), style: .plain, target: self, action: nil)
//        self.navigationController?.navigationBar.topItem?.title = "GoGoGo"

        // Do any additional setup after loading the view.
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
