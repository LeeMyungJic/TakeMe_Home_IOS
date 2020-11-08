//
//  Get.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import Foundation

let session: URLSession = URLSession.shared

func Get(param: [String:Any],url: URL) {
    let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
    var request = URLRequest(url: url)
    request.httpBody = paramData
    
    // 4. HTTP 메시지에 포함될 헤더 설정
    request.httpMethod = "GET"

    // 4. HTTP 메시지에 포함될 헤더 설정
    request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

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
    // GET 전송
    task.resume()
}

//let url2 = URL(string: NetWorkController.baseUrl + "/api/v1/customers/customer/1")
//
//Get(url: url2!)

//특수문자 인코딩
//let urlStr = NetWorkController.baseUrl + "/api/v1/customers/customer/1"
//let enco = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
