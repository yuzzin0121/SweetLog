//
//  KakaoNetworkManager.swift
//  SweetLog
//
//  Created by 조유진 on 5/7/24.
//
import Foundation
import Alamofire
import RxSwift
final class KakaoNetworkManager {
    
    static let shared = KakaoNetworkManager()
    
    func searchPlace(query: SearchPlaceQuery) -> Single<PlaceModel> {
        return Single<PlaceModel>.create { single in
            do {
                let urlRequest = try KakaoPlaceRouter.searchPlace(query: query).asURLRequest()
                print(urlRequest)

                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PlaceModel.self) { response in
                        switch response.result {
                        case .success(let placeModel):
                            single(.success(placeModel))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                if let apiError = APIError(rawValue: statusCode) {
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
