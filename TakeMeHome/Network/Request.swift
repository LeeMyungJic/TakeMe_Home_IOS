
func Request(url: String, type: HttpMethod, body: Data? = nil) {
    guard let url = URL(string: url) else { return }
    
    // 1. 요청 객체 생성
    var request = URLRequest(url: url)
    // 2. 요청 방식
    request.httpMethod = type.rawValue
    // 3. 헤더
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // 4. 바디
    request.httpBody = body
    // 5. Session
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        do {
            let anyData = try JSONSerialization.jsonObject(with: data!, options: [])
            print(anyData)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // 6. 실행
    task.resume()
}
