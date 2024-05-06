//
//  NetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    
    func requestToServer<T: Decodable, U: TargetType>(model: T.Type, router: U) -> Single<Result<T, Error>> {
        return Single<Result<T, Error>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            single(.success(.success(model)))
                        case .failure(let error):
                            print("failure: \(error)")
                            guard let statusCode = response.response?.statusCode else {
                                single(.success(.failure(APIError.serverError)))
                                return
                            }
                            if let apiError = APIError(rawValue: statusCode) {
                                single(.success(.failure(apiError)))
                            } 
                        }
                    }
            } catch {
                single(.success(.failure(APIError.serverError)))
            }
            
            return Disposables.create()
        }
    }
    
    // 토큰 갱신
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
                    if let code = response.response?.statusCode, let error = APIError(rawValue: code) {
                        print("토큰 갱신 실패: \(code)")
                        if error == .refreshTokenExpired {
                            print(error.errorDescription)
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
