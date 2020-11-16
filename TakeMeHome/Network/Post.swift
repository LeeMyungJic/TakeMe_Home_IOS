//
//  Post.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import Foundation

func Post(param: [String:Any], url: URL, isGet: Bool = false, person: String = "") {
    let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = paramData
    
    // 4. HTTP 메시지에 포함될 헤더 설정
    request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
    print("====================================================")
    print("====================================================")
    // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
    
    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString)")
        
        
        do {
            // JSONSerialization로 데이터 변환하기
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            {
                
                if let temp2 = json["data"] as? Int {
                    
                    
                }
            }
            
        }
        catch {
            print("JSON 파상 에러")
            
        }
        print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
        
        
        
        if let e = error {
            NSLog("An error has occured: \(e.localizedDescription)")
            return
        }
        // 응답 처리 로직
        
    }
    // POST 전송
    task.resume()
}
