//
//  StarButton.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class StarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
//        var config = UIButton.Configuration.filled()
//        config.baseBackgroundColor = Color.sugarBrown
//        config.cornerStyle = .capsule
//        configuration = config
        setImage(Image.star, for: .normal)
        tintColor = Color.sugarBrown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
