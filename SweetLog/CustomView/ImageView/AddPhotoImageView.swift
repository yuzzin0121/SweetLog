//
//  AddPhotoImageView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class AddPhotoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
        image = Image.addPhoto
        layer.borderColor = Color.buttonStrokeGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
