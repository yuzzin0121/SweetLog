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
 
    
    
}
