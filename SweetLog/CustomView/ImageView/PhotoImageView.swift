//
//  PhotoImageView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class PhotoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
