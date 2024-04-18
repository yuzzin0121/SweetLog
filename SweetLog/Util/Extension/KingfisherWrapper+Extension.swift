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
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
   
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            return request
        }
        
        let newOptions: KingfisherOptionsInfo = options ?? [] + [.requestModifier(modifier)]
        
        self.setImage(
            with: resource,
            placeholder: placeholder,
            options: newOptions,
            progressBlock: progressBlock,
            completionHandler: completionHandler
        )
    }
}
