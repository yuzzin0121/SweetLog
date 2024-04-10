//
//  LoginQuery.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation

//HTTP Post
struct LoginQuery: Encodable {
    let email: String
    let password: String
}
