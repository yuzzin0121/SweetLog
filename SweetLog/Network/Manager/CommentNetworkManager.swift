//
//  CommentNetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import Foundation
import RxSwift
import Alamofire

final class CommentNetworkManager {
    
    static let shared = CommentNetworkManager()
 
    
    func deleteComment(postId: String, commentId: String) -> Single<String> {
        print(#function)
        return Single<String>.create { single in
            do {
                let urlRequest = try CommentRouter.deleteComment(postId: postId, commentId: commentId).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .response(completionHandler: { response in
                        switch response.result {
                        case .success(let response):
                            print("성공")
                            single(.success(commentId))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    })
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
