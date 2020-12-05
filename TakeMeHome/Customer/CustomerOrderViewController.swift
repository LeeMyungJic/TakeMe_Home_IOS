import UIKit

class CustomerOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var restaurantId : Int?
    static var userId : Int?
    
    @IBOutlet var TableMain: UITableView!
    var stores = [store]()
    var canDelivery = [store]()
    
    
    func getStores() {
        stores = [store]()
        print("getStore")
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants")!) { (data, response, error) in
            if let dataJson = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
                            if let temp2 = temp["restaurantFindAllResponse"] as? NSArray {
                                for i in temp2 {
                                    if let temp = i as? NSDictionary {
                                        let nameStr = temp["name"] as! String
                                        let idStr = temp["id"] as! Int
                                        self.stores.append(store(name: nameStr, id: idStr))
                                            
                                        
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
        task.resume()
    }
    
    func isDelivery(item: store) {
        print("isDelivery")
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/restaurant/\(item.id)/\(CustomerOrderViewController.userId!)/distance")!) { (data, response, error) in
                if let dataJson = data {
                    
                    do {
                        // JSONSerialization로 데이터 변환하기
                        if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                        {
    //                        if let temp = json["address"] as? [String:Any] {
    //                            print("data!!")
    //                            self.addressStr = temp as? String
    //                        }
                            
                            if let temp = json["data"] as? [String:Any] {
                                print("data!!")
                                guard let price = temp["price"] as? Int else {
                                    return
                                }
                                self.canDelivery.append(item)
                                
                              
                            }
                            
                        }
                    }
                    catch {
                        
                    }
                }
            }
            task.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "CustomerOrderCell", for: indexPath) as! CustomerOrderCell
        
        cell.StoreName.text = stores[indexPath.row].name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStores()

        print("getget : \(canDelivery.count)")
        //print(self.stores.count)
        //self.isDelivery()
        TableMain.delegate = self
        TableMain.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let id = segue.identifier, "gogo" == id {
            if let controller = segue.destination as? StoreDetailViewController {
                if let indexPath = TableMain.indexPathForSelectedRow {
                    StoreDetailViewController.restaurantName = stores[indexPath.row].name
                    StoreDetailViewController.restaurantId = stores[indexPath.row].id
                    
                }
            }
        }
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

struct store {
    var name : String?
    var id : Int?
}
