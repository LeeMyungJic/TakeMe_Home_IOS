//
//  MenuViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/08.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menus = [menu]()
    
    var completionHandler: (() -> ())?
    
    func getMenus() {
        menus = [menu]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/menus/" + "\(ManagerCallViewController.restaurantId)")!) { (data, response, error) in
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        
                        if let temp2 = json["data"] as? NSArray {
                            var getName : String?
                            var getPrice : Int?
                            var getStatus : String?
                            var getMenuId : Int?
                            for item in temp2 {
                                if let temp = item as? NSDictionary {
                                    getName = temp["name"] as? String
                                    getPrice = temp["price"] as? Int
                                    getStatus = temp["menuStatus"] as? String
                                    getMenuId = temp["id"] as? Int
                                    self.menus.append(menu(name: getName, price: getPrice, status: getStatus, menuId: getMenuId))
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
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.name.text = menus[indexPath.row].name
        cell.price.text = "\(menus[indexPath.row].price!)원"
        if menus[indexPath.row].status == "SALE" {
            cell.status.text = "판매중"
        }
        else {
            cell.status.text = "품절"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Owner", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "ChangeStatusViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        ChangeStatusViewController.menuId = menus[indexPath.row].menuId!
        
        let temp = popUp as? ChangeStatusViewController
        
        temp?.getName = menus[indexPath.row].name!
        temp?.getPrice = menus[indexPath.row].price!
        
        
        self.present(popUp, animated: true, completion: nil)
        
        _ = completionHandler?()
        
        temp?.completionHandler = {
            
        }
        guard let moveFirst = tabBarController?.viewControllers?[3] else {
            return
        }
        tabBarController?.selectedViewController = moveFirst
        
    }
    
    
    @IBOutlet var TableMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableMain.delegate = self
        TableMain.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMenus()
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

struct menu {
    var name: String?
    var price: Int?
    var status: String?
    var menuId: Int?
}
