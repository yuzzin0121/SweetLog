//
//  SearchBar.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class SearchBar: UISearchBar {
    
    init(placeholder: String, backgroundColor: UIColor = Color.gray1) {
        super.init(frame: .zero)
        configureView(placeholder: placeholder, backgroundColor: backgroundColor)
    }
    
    private func configureView(placeholder: String, backgroundColor: UIColor = Color.gray1) {
        searchBarStyle = .minimal
        layer.cornerRadius = 24
        clipsToBounds = true
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        barTintColor = Color.gray1
        layer.borderWidth = 0
        setImage(Image.search, for: .search, state: .normal)
        setImage(Image.x, for: .clear, state: .normal)
        
        if let textField = value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .none
            textField.font = .pretendard(size: 14, weight: .regular)
            textField.backgroundColor = backgroundColor
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트컬러 정하기
                leftView.tintColor = Color.gray4
            }
            //오른쪽 x버튼 이미지넣기
            if let rightView = textField.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트 정하기
                rightView.tintColor = UIColor.gray4
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
