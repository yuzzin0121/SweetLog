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
    
    func createComment(postId: String?, contentQuery: ContentQuery) -> Single<Comment> {
        return Single<Comment>.create { single in
            do {
                guard let postId else {
                    single(.failure(Error.self as! Error))
                    return Disposables.create()
                }
                let urlRequest = try CommentRouter.createComment(postId: postId, contentQuery: contentQuery).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Comment.self) { response in
                        switch response.result {
                        case .success(let commentResponseModel):
                            single(.success(commentResponseModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let createCommentError = fetchPostError(rawValue: statusCode) {
                                    print("createCommentError")
                                    single(.failure(createCommentError))
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
