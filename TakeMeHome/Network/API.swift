class API {
    // 1
    enum APIError: LocalizedError {
        case urlNotSupport
        case noData
        
        var errorDescription: String?
        {
            switch self {
            case .urlNotSupport: return "URL NOT Supported"
            case .noData: return "Has No Data"
                
            }
        }
    }
// 2
    static let shared: API = API()
    
    private lazy var defaultSession = URLSession(configuration: .default)
    
    
    private init() { }
// 3
    func get1(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/posts")
        else { completionHandler(.failure(.urlNotSupport))
            return
            
        }
        let resource = Resource<[UserData]>(url: url)
        defaultSession.load(resource) { userDatas, _ in guard let data = userDatas, !data.isEmpty else { completionHandler(.failure(.noData))
            return }
            completionHandler(.success(data))
            
        }
        
    }
    
    func get2(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        let resource = Resource<[UserData]>(url: "\(Config.baseURL)/posts", parameters: ["userId": "1"])
        defaultSession.load(resource) { userDatas, _ in guard let data = userDatas, !data.isEmpty else { completionHandler(.failure(.noData))
            return }
            completionHandler(.success(data)) } }
    
    func post(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/posts") else { completionHandler(.failure(.urlNotSupport))
            return
            
        }
        let userData = PostUserData()
        let resource = Resource<PostUserData>(url: url, method: .post(userData))
        defaultSession.load(resource) { userData, _ in guard let data = userData else { completionHandler(.failure(.noData))
            return }
            completionHandler(.success([data.toUserData()]))
            
        }
        
    }
    
    func put(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/posts/1") else { completionHandler(.failure(.urlNotSupport))
            return }
        let userData = PostUserData(id: 1)
        let resource = Resource<PostUserData>(url: url, method: .put(userData))
        defaultSession.load(resource) { userData, _ in guard let data = userData else { completionHandler(.failure(.noData))
            return }
            completionHandler(.success([data.toUserData()]))
            
        }
        
    }
    
    func patch(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/posts/1") else { completionHandler(.failure(.urlNotSupport))
        return }
        let userData = PostUserData(id: 1)
        let resource = Resource<PostUserData>(url: url, method: .patch(userData))
        defaultSession.load(resource) { userData, _ in guard let data = userData else { completionHandler(.failure(.noData))
            return
            
        }
            completionHandler(.success([data.toUserData()]))
        
        }
        
    }
    
    func delete(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/posts/1") else { completionHandler(.failure(.urlNotSupport))
            return
            
        }
        let userData = PostUserData()
        let resource = Resource<UserData>(url: url, method: .delete(userData))
        defaultSession.load(resource) { userData, response in if response { completionHandler(.success([UserData(userId: -1, id: -1, title: "DELETE", body: "SUCCESS")])) } else { completionHandler(.failure(.noData)) } } } }

