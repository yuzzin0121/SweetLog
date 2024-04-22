//
//  TargetType.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import Alamofire
 
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: String? { get }
    var body: Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(string: baseURL.appending(path))
        components?.queryItems = queryItems

        guard let componentsURL = components?.url else { throw URLError(.badURL) }
        var urlRequest = try URLRequest(url: componentsURL, method: method)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        return urlRequest
    }
}
