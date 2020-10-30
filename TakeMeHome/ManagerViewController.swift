//
//  ManagerViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import UIKit

class ManagerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    static var stores = ["한신포차", "1943", "신포닭발", "당구클럽"]
    @IBOutlet var TableMain: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManagerViewController.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
        cell.StoreName.text = ManagerViewController.stores[indexPath.row]
        
        return cell
    }
    

    @IBOutlet var StoreName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GOGOGOGOGOOGO")
        TableMain.delegate = self
        TableMain.dataSource = self

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
