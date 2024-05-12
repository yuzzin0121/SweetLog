//
//  NetworkConnectionErrorView.swift
//  SweetLog
//
//  Created by 조유진 on 5/13/24.
//

import UIKit

final class NetworkConnectionErrorView: UIView, ViewProtocol {
    let errorMessageLabel = UILabel()
    let connectionImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubviews([connectionImageView, errorMessageLabel])
    }
    
    func configureLayout() {
        connectionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        errorMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(connectionImageView.snp.bottom).offset(40)
        }
    }
    
    func configureView() {
        backgroundColor = Color.white.withAlphaComponent(0.7)
        connectionImageView.image = Image.wifiProblem
        errorMessageLabel.design(text: "네트워크가 연결되지 않았습니다.\nWi-Fi 또는 데이터를 활성화 해주세요", textColor: Color.validRed, font: .pretendard(size: 18, weight: .medium), textAlignment: .center, numberOfLines: 2)
        errorMessageLabel.setLineSpacing(spacing: 10)
    }
}
