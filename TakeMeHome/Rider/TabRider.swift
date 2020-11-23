//
//  TabRider.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/23.
//

import UIKit

class TabRider: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/customers/customer/" + "\(CallViewController.riderId!)" + "/logout")
        let param = [:] as [String : Any]
        Delete(param: param, url: url!)
        print("Logout !!")
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
