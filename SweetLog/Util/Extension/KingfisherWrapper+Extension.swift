//
//  KingfisherWrapper+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import UIKit
import Kingfisher


extension KingfisherWrapper where Base: UIImageView {
    func setImageWithAuthHeaders(
        with urlString: String,
        completionHandler: @escaping (Bool) -> Void)
     {
         do {
             let request = try PostRouter.loadImage(url: urlString).asURLRequest()
             
             let modifier = AnyModifier { _ in
                    return request
             }
             print(urlString)
             setImage(
                with: request.url,
                placeholder: nil,
                options: [.requestModifier(modifier)]
             ) { response in
                 switch response {
                 case .success(_):
                     completionHandler(true)
                 case .failure(let error):
                     print(error.errorCode)
                     completionHandler(false)
                 }
             }
         } catch {
             completionHandler(false)
         }
    }
}
