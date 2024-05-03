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
        configureView()
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
