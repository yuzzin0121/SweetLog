//
//  ProfileManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import Foundation
import Alamofire
import RxSwift

class ProfileNetworkManager {
    static let shared = ProfileNetworkManager()
    
    // 내 프로필 조회
    func fetchMyProfile() -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.fetchMyProfile.asURLRequest()
                                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let profileModel):
                            single(.success(profileModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let fetchMyProfileError = LoginError(rawValue: statusCode) {
                                    print("fetchMyProfileError")
                                    single(.failure(fetchMyProfileError))
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
    
    // 사용자 프로필 조회
    func fetchUserProfile(userId: String) -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.fetchUserProfile(userId: userId).asURLRequest()
                                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let profileModel):
                            single(.success(profileModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let fetchMyProfileError = LoginError(rawValue: statusCode) {
                                    print("fetchMyProfileError")
                                    single(.failure(fetchMyProfileError))
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
 
    // 프로필 수정 - 닉네임, 프로필 이미지
    func editMyProfile(nickname: String?, profile: Data?) -> Single<ProfileModel> {
        print("nickname: \(nickname), profile: \(profile)")
        
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.editMyProfile.asURLRequest()
                
                guard let url = urlRequest.url else {
                    single(.failure(APIError.invalidURL))
                    return Disposables.create()
                }
                
                AF.upload(multipartFormData: { multipartFormData in
                    if let nickname {
                        multipartFormData.append("\(nickname)".data(using: .utf8)!, withName: "nick")
                    }
                    
                    if let profileData = profile {
                        multipartFormData.append(profileData,
                                                 withName: "profile",
                                                 fileName: "profile.jpg",
                                                 mimeType: "image/jpg")
                    }
                    
                }, with: urlRequest, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ProfileModel.self) { response in
                    switch response.result {
                    case .success(let profileModel):
                        single(.success(profileModel))
                    case .failure(let error):
                        print(error)
                        if let statusCode = response.response?.statusCode {
                            if let editProfileError = fetchPostError(rawValue: statusCode) {
                                print("editProfileError")
                                single(.failure(editProfileError))
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
