//
//  NetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire


final class NetworkManager {
    static let shared = NetworkManager()
    
    func tokenRefresh(completionHandler: @escaping (Bool) -> Void) {
        do {
            let urlRequest = try AuthRouter.refresh.asURLRequest()
            
            AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshModel.self, completionHandler: { response in
                switch response.result {
                case .success(let success):
                    let accessToken = success.accessToken
                    UserDefaultManager.shared.accessToken = accessToken
                    completionHandler(true)
                case .failure(let failure):
                    print(failure)
                    if let code = response.response?.statusCode {
                        print("토큰 갱신 실패: \(code)")
                        if code == 418 {
                            print("로그인이 필요합니다.")
                        }
                    } else {
                        print("토큰 갱신 실패")
                    }
                    completionHandler(false)
                }
            })
        } catch {
            completionHandler(false)
        }
    }
}
