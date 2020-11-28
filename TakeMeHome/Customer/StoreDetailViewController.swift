import UIKit

class StoreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var restaurantName : String?
    static var restaurantId : Int?
    @IBOutlet var Label: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    var completionHandler: (() -> ())?
    var menus = [menu]()
    
    var totalPriceValue = 0
    var isClick = false
    
    @IBOutlet var TableMain: UITableView!
    
    func getMenus() {
        menus = [menu]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/menus/" + "\(StoreDetailViewController.restaurantId!)")!) { (data, response, error) in
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
        let cell = TableMain.dequeueReusableCell(withIdentifier: "StoreDetailCell", for: indexPath) as! StoreDetailCell
        
        cell.Name.text = menus[indexPath.row].name
        cell.Price.text = "\(menus[indexPath.row].price!)원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Customer", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "CountOfProduct")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? CountOfProductViewController
        
        temp?.productPrice = menus[indexPath.row].price!
        temp?.nameStr = menus[indexPath.row].name
        temp?.menuId = menus[indexPath.row].menuId!
        
        
        self.present(popUp, animated: true, completion: nil)
        _ = completionHandler?()
        
        temp?.completionHandler = {
            result in
            print("result : \(result)")
            self.totalPriceValue += result
            DispatchQueue.main.async {
                self.totalPrice.text = "\(self.totalPriceValue) 원"
            }
            //self.totalPrice.text = "\(result) 원"
            return result
        }
        
        
    
        
        print("디테일 뷰에서 값 : \(totalPriceValue)")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .lightGray
        TableMain.delegate = self
        TableMain.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       
        getMenus()
        LastOrderViewController.menuList = [menuAndCount]()
        LastOrderViewController.price = [Int]()
        Label.text = StoreDetailViewController.restaurantName
        
    }
    @IBAction func Pay(_ sender: Any) {
        if totalPriceValue != 0 {
            guard let temp = storyboard?.instantiateViewController(identifier: "LastOrderViewController") as? LastOrderViewController else { return }
            present(temp, animated: true, completion: nil)
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

