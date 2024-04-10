//
//  SignButton.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

class SignButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel?.font = .pretendard(size: 17, weight: .regular)
        setTitle(title, for: .normal)
        setTitleColor(Color.white, for: .normal)
        backgroundColor = Color.brown
        layer.cornerRadius = 20
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
