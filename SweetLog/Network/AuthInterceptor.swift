//
//  AuthInterceptor.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.setValue(UserDefaultManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == APIError.accessTokenExpired.rawValue else {
            print("sdfsdfg")
            return completion(.doNotRetryWithError(error))
        }
        
        refreshAccessToken { isSuccess in
            if isSuccess {
                print("갱신 성공")
                completion(.retry)
            } else {
                print("refresh token 만료됨, 로그인 필요")
                NotificationCenter.default.post(name: .refreshTokenExpired, object: nil, userInfo: nil)
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping(Bool) -> Void) {
        print("refreshAccessToken")
        NetworkManager.shared.tokenRefresh { isSuccess in
            completion(isSuccess)
        }
    }
}
