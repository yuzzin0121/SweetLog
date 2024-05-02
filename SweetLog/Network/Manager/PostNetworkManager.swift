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
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchPosts(query: fetchPostQuery).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let fetchPostModel):
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
        }
    }
    
    func fetchPost(postId: String) -> Single<FetchPostItem> {
        print(#function)
        return Single<FetchPostItem>.create { single in
            do {
                let urlRequest = try PostRouter.fetchPost(postId: postId).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostItem.self) { response in
                        switch response.result {
                        case .success(let fetchPostItem):
                            single(.success(fetchPostItem))
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
        }
    }
    
    // 이미지 업로드
    func uploadImages(imageDataList: [Data]) -> Single<FilesModel> {
        return Single<FilesModel>.create { single in
            do {
                let urlRequest = try PostRouter.uploadFiles.asURLRequest()
                
                guard let url = urlRequest.url else {
                    single(.failure(APIError.invalidURL))
                    return Disposables.create()
                }
                
                AF.upload(multipartFormData: { multipartFormData in
                    for data in imageDataList {
                        multipartFormData.append(data,
                                                 withName: "files",
                                                 fileName: "sweet.jpg",
                                                 mimeType: "image/jpg")
                    }
                }, to: url, headers: urlRequest.headers, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: FilesModel.self) { response in
                    switch response.result {
                    case .success(let filesModel):
                        single(.success(filesModel))
                    case .failure(let error):
                        print(error)
                        if let statusCode = response.response?.statusCode {
                            if let uploadFileError = fetchPostError(rawValue: statusCode) {
                                print("uploadFileError")
                                single(.failure(uploadFileError))
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
    
    func createPost(postRequestModel: PostRequestModel?) -> Single<FetchPostItem> {
        return Single<FetchPostItem>.create { single in
            do {
                guard let postRequestModel else {
                    single(.failure(APIError.invalidURL))
                    return Disposables.create()
                }
                let urlRequest = try PostRouter.createPost(postQuery: postRequestModel).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostItem.self) { response in
                        switch response.result {
                        case .success(let postModel):
                            single(.success(postModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let createPostError = fetchPostError(rawValue: statusCode) {
                                    print("createPostError")
                                    single(.failure(createPostError))
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
    
    func likePost(postId: String, likeStatusModel: LikeStatusModel) -> Single<LikeStatusModel> {
        return Single<LikeStatusModel>.create { single in
            do {
                let urlRequest = try PostRouter.likePost(postId: postId, likeStatusModel: likeStatusModel).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LikeStatusModel.self) { response in
                        switch response.result {
                        case .success(let likeStatusModel):
                            single(.success(likeStatusModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let likePostError = LikePostError(rawValue: statusCode) {
                                    print("likePostError")
                                    single(.failure(likePostError))
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
    
    func fetchUserPosts(fetchPostQuery: FetchPostQuery, userId: String) -> Single<FetchPostModel> {
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchUserPost(query: fetchPostQuery, userId: userId).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let fetchPostModel):
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
        }
    }
    
    func fetchMyLikePost(fetchPostQuery: FetchPostQuery) -> Single<FetchPostModel> {
        return Single<FetchPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.fetchMyLikePost(query: fetchPostQuery).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: FetchPostModel.self) { response in
                        switch response.result {
                        case .success(let fetchPostModel):
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
        }
    }
    
    func deletePost(postId: String) -> Single<String> {
        print(#function)
        return Single<String>.create { single in
            do {
                let urlRequest = try PostRouter.deletePost(postId: postId).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .response(completionHandler: { response in
                        switch response.result {
                        case .success(let response):
                            print("성공")
                            single(.success(postId))
                        case .failure(let error):
                            print("실패ㅠㅠ\(response.response?.statusCode)")
                            single(.failure(error))
                        }
                    })
            } catch {
                print("이건 Router 문제야")
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
