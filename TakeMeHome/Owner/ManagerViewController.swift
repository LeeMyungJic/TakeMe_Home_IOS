//
//  ManagerViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import UIKit

class ManagerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var stores = [getItem]()
    static var ownerId : Int?
    @IBOutlet var TableMain: UITableView!
    
    var selectedIndex = -1
    
    
    func getStores() {
        stores = [getItem]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/1")!) { (data, response, error) in
            
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        //print(json["data"] as? [String:Any])
                        print(json)
                        if let temp = json["data"] as? [String:Any] {
                            if let temp2 = temp["restaurantFindAllResponse"] as? NSArray {
                                for i in temp2 {
                                    if let temp = i as? NSDictionary {
                                        print(temp["name"] as! String)
                                        if let tempLocation = temp["location"] as? [String:Any]{
                                        
                                        self.stores.append(getItem(address: temp["address"] as? String, name: temp["name"] as! String, id: temp["id"] as? Int, location: getLocation(x: tempLocation["x"] as? Double, y: tempLocation["y"] as? Double), number: temp["number"] as! String))
                                        
                                    }
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
                
            }
            
            
            
            // UI부분이니까 백그라운드 말고 메인에서 실행되도록 !
            DispatchQueue.main.async {
                //reloadData로 데이터를 가져왔으니 쓰라고 통보 ㅎㅎ
                self.TableMain.reloadData()
            }
            
        }
        // Json Parsing
        
        
        task.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    @IBAction func addStore(_ sender: Any) {
        let addStore = self.storyboard?.instantiateViewController(withIdentifier: "AddRestaurantViewController")
        self.present(addStore!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
        cell.StoreName.text = stores[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ManagerCallViewController.getStoreName = stores[indexPath.row].name!
        ManagerCallViewController.restaurantId = stores[indexPath.row].id!
        selectedIndex = indexPath.row
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let storyboard = UIStoryboard.init(name: "Owner", bundle: nil)
//        
//        let popUp = storyboard.instantiateViewController(identifier: "UpdateStoreViewController")
//        
//        let temp = popUp as? UpdateStoreViewController
//        
//        temp?.rName = stores[selectedIndex].name
//        temp?.rAddress = stores[selectedIndex].address
//        temp?.rNumber = stores[selectedIndex].number
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStores()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableMain.delegate = self
        TableMain.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/customers/customer/" + "\(ManagerViewController.ownerId!)" + "/logout")
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

struct getItem {
    var address: String?
    var name : String?
    var id : Int?
    var location : getLocation?
    var number : String?
}

struct getLocation {
    var x : Double?
    var y : Double?
}

