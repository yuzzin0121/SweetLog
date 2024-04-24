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
                let urlRequest = try PostRouter.fetchPost(query: fetchPostQuery).asURLRequest()
                                
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
}
