//
//  Post.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import Foundation

func Delete(param: [String:Any], url: URL) {
    let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.httpBody = paramData
    
    // 4. HTTP 메시지에 포함될 헤더 설정
    request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
    
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
        if let e = error {
            NSLog("An error has occured: \(e.localizedDescription)")
            return
        }
        // 응답 처리 로직
       
    }
    // POST 전송
    task.resume()
}
