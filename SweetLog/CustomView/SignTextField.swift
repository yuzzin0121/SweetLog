//
//  SignTextField.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class SignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        addLeftPadding()
        font = .pretendard(size: 17, weight: .regular)
        textColor = Color.black
        placeholder = placeholderText
        borderStyle = .none
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = Color.borderGray.cgColor
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
