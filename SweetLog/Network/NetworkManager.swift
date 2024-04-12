//
//  NetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/12/24.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkManager {
    
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(loginModel))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func validationEmail(email: ValidationQuery) -> Single<ValidationModel> {
        print(#function, email)
        return Single<ValidationModel>.create { single in
            do {
                let urlRequest = try Router.validation(email: email).asURLRequest()
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
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
