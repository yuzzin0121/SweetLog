//
//  ProfileInfoView.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import UIKit

final class ProfileInfoView: UIView, ViewProtocol {
    let stackView = UIStackView()
    let countLabel = UILabel()
    let titleLabel = UILabel()
    
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
        addSubview(stackView)
        [countLabel, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configureView() {
        stackView.design(alignment: .center, spacing: 10)
        countLabel.design(font: .pretendard(size: 16, weight: .semiBold))
        titleLabel.design(font: .pretendard(size: 14, weight: .regular))
    }
}
