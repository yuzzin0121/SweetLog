//
//  FilterButton.swift
//  SweetLog
//
//  Created by 조유진 on 4/21/24.
//

import UIKit

final class FilterButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseForegroundColor = Color.darkBrown
        config.baseBackgroundColor = Color.white
        config.background.strokeColor = Color.buttonStrokeGray
        config.background.strokeWidth = 1
        configuration = config
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

