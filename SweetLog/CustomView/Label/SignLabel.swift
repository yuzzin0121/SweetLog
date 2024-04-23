//
//  SignLabel.swift
//  SweetLog
//
//  Created by 조유진 on 4/12/24.
//

import UIKit

final class SignLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        font = .pretendard(size: 17, weight: .semiBold)
        text = title
        textColor = Color.black
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
