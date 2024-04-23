//
//  MenuButton.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class MenuButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configureView()
    }
    
    private func configureView() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = Color.black
        configuration.baseBackgroundColor = Color.white
        configuration.title = FilterItem.allCases[0].title
        configuration.image = Image.arrowDown
        configuration.image?.withTintColor(Color.black)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
