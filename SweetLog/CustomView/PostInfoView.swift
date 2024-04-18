//
//  PostInfoView.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import UIKit

final class PostInfoView: UIView {
    let stackView = UIStackView()
    let imageView = UIImageView()
    let countLabel = UILabel()
    
    init(image: UIImage, count: Int) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        addSubview(stackView)
        [imageView, countLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        countLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }
    
    func configureView() {
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
