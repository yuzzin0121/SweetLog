//
//  PostNetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire
import RxSwift

final class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    
    func fetchPosts(fetchPostQuery: FetchPostQuery) -> Single<FetchPostModel> {
        print(#function, "\(fetchPostQuery)")
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchPost(query: fetchPostQuery).asURLRequest()
                print("=======\(urlRequest)")
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let fetchPostModel):
                            print("포스트 조회 결과=========\(fetchPostModel.data)========")
                            single(.success(fetchPostModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let fetchPostError = fetchPostError(rawValue: statusCode) {
                                    print("fetchPostError")
                                    single(.failure(fetchPostError))
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
        }.debug()
    }
}
