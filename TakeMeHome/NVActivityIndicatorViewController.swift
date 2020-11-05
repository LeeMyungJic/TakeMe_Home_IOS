//
//  NVActivityIndicatorViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import UIKit
import NVActivityIndicatorView

class NVActivityIndicatorViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 162, y: 100, width: 50, height: 50),
                                                type: .circleStrokeSpin,
                                                color: .black,
                                                padding: 0)
        mainView.addSubview(indicator)
        indicator.startAnimating()

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
