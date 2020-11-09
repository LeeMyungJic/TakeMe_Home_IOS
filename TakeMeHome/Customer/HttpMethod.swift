enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
    case patch(Body)
    case delete(Body)
    
}
extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE" }
        
    }
    
}
struct UserData: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}
struct PostUserData: Codable {
    let userId: String
    let id: Int?
    let title: String
    let body: String
    init(id: Int? = nil) {
        self.userId = "1"
        self.title = "Title"
        self.body = "Body"
        self.id = id
        
    }
    func toUserData() -> UserData {
        return UserData(userId: Int(userId) ?? 0, id: id ?? 0, title: title, body: body)
        
    }
    
}
struct PatchUserData: Decodable {
    let userId: String
    let id: String
    let title: String
    let body: String
    func toUserData() -> UserData {
        return UserData(userId: Int(userId) ?? 0, id: Int(id) ?? 0, title: title, body: body)
        
    }
}

struct Resource<T> {
    var urlRequest: URLRequest
    let parse: (Data) -> T?
    
}
extension Resource where T: Decodable {
    // 1
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = {
            data in try? JSONDecoder().decode(T.self, from: data)
            
        }
        
    }
    // 2
    init(url: String, parameters _parameters: [String: String]) {
        var component = URLComponents(string: url)
        var parameters = [URLQueryItem]()
        for (name, value) in _parameters {
            if name.isEmpty {
                continue
                
            }
            parameters.append(URLQueryItem(name: name, value: value)) }
        if !parameters.isEmpty {
            component?.queryItems = parameters
            
        }
        if let componentURL = component?.url {
            self.urlRequest = URLRequest(url: componentURL)
            
        }
        else {
            self.urlRequest = URLRequest(url: URL(string: url)!) }
        self.parse = {
            data in try? JSONDecoder().decode(T.self, from: data)
            
        }
        
    }
    // 3
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        switch method {
        case .post(let body), .delete(let body), .patch(let body), .put(let body):
            self.urlRequest.httpBody = try? JSONEncoder().encode(body)
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        default: break
            
        }
        self.parse = { data in try? JSONDecoder().decode(T.self, from: data)
            
        }
        
    }
    
}

extension URLSession {
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, Bool) -> Void) {
        dataTask(with: resource.urlRequest) { data, response, _ in if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) { completion(data.flatMap(resource.parse), true) }
        else { completion(nil, false) }
            
        }.resume()
        
    }
    
}



