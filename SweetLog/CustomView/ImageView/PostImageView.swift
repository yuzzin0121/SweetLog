//
//  PostImageView.swift
//  SweetLog
//
//  Created by 조유진 on 4/21/24.
//

import UIKit

final class PostImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

