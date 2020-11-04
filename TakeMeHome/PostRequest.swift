import Cocoa

let session: URLSession = URLSession.shared
    
// POST METHOD
func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    var request: URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
    request.httpBody = "id=\(String(describing: body.value(forKey: "id")!))&pwd=\(String(describing: body.value(forKey: "pwd")!))".data(using: .utf8)
    session.dataTask(with: request, completionHandler: completionHandler).resume()
}

let url: URL = URL(string: "http://192.168.0.26:8080/login")!
let body: NSMutableDictionary = NSMutableDictionary()
body.setValue("kdhong", forKey: "id")
body.setValue("1234", forKey: "pwd")
try post(url: url, body: body, completionHandler: { data, response, error in
    guard let data = data else { return }
    print(String(data: data, encoding: .utf8)!)
})
