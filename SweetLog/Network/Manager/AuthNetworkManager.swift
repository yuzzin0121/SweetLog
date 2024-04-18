//
//  NetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/12/24.
//

import Foundation
import Alamofire
import RxSwift

struct AuthNetworkManager {
    // 로그인
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try AuthRouter.login(query: query).asURLRequest()
                                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(loginModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let loginError = LoginError(rawValue: statusCode) {
                                    print("loginError")
                                    single(.failure(loginError))
                                } else if let apiError = APIError(rawValue: statusCode) {
                                    single(.failure(apiError))
                                }
                            } else {
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    // 이메일 중복 확인
    static func validationEmail(email: ValidationQuery) -> Single<ValidationModel> {
        print(#function, email)
        return Single<ValidationModel>.create { single in
            do {
                let urlRequest = try AuthRouter.validation(email: email).asURLRequest()
                print(urlRequest)
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ValidationModel.self) { response in
                        switch response.result {
                        case .success(let message):
                            print(message)
                            single(.success(message))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let validEmailError = ValidationEmailError(rawValue: statusCode) {
                                    print("ValidEmailError")
                                    single(.failure(validEmailError))
                                } else if let apiError = APIError(rawValue: statusCode) {
                                    single(.failure(apiError))
                                }
                            } else {
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    // 회원가입
    static func createJoin(query: JoinQuery) -> Single<JoinModel> {
        print(query.email, query.password, query.nick)
        return Single<JoinModel>.create { single in
            do {
                let urlRequest = try AuthRouter.join(query: query).asURLRequest()
                                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: JoinModel.self) { response in
                        switch response.result {
                        case .success(let joinModel):
                            single(.success(joinModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let joinError = JoinError(rawValue: statusCode) {
                                    print("JoinError")
                                    single(.failure(joinError))
                                } else if let apiError = APIError(rawValue: statusCode) {
                                    single(.failure(apiError))
                                }
                            } else {
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func withdraw() -> Single<JoinModel> {
        return Single<JoinModel>.create { single in
            do {
                let urlRequest = try AuthRouter.withdraw.asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: JoinModel.self) { response in
                        switch response.result {
                        case .success(let joinModel):
                            single(.success(joinModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let withdrawError = withdrawError(rawValue: statusCode) {
                                    print("withdrawError")
                                    single(.failure(withdrawError))
                                } else if let apiError = APIError(rawValue: statusCode) {
                                    single(.failure(apiError))
                                }
                            } else {
                                single(.failure(error))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
//    static func refreshAccessToken(completionHandler: @escaping (Bool) -> Void) {
//        do {
//            let urlRequest = try AuthRouter.refresh.asURLRequest()
//                            
//            AF.request(urlRequest)
//                .validate(statusCode: 200..<300)
//                .responseDecodable(of: RefreshModel.self) { response in
//                    switch response.result {
//                    case .success(let refreshModel):
//                        completionHandler(true)
//                    case .failure(let error):
//                        print(error)
//                        if let statusCode = response.response?.statusCode {
//                            if let refreshError = refreshError(rawValue: statusCode) {
//                                print("withdrawError")
//                                completionHandler(false)
//                            } else if let apiError = APIError(rawValue: statusCode) {
//                                completionHandler(false)
//                            }
//                        } else {
//                            completionHandler(false)
//                        }
//                    }
//                }
//        } catch {
//            completionHandler(false)
//        }
//    }
}
