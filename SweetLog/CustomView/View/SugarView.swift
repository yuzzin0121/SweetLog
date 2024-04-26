//
//  SugarView.swift
//  SweetLog
//
//  Created by 조유진 on 4/26/24.
//

import UIKit

final class SugarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureView()
    }
    
    private func configureView() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        backgroundColor = Color.sugarBrown
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
