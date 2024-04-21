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
        configureView(image: image, count: count)
    }
    
    func configureHierarchy() {
        addSubview(stackView)
        [imageView, countLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configureView(image: UIImage, count: Int) {
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        
        imageView.image = image
        imageView.tintColor = Color.gray
        countLabel.text = "\(count)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
