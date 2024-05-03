//
//  SearchBar.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class SearchBar: UISearchBar {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configureView(placeholder: placeholder)
    }
    
    private func configureView(placeholder: String) {
        searchBarStyle = .minimal
        layer.cornerRadius = 24
        clipsToBounds = true
        self.placeholder = placeholder
        backgroundColor = Color.gray1
        barTintColor = Color.gray1
        layer.borderWidth = 0
        setImage(Image.search, for: .search, state: .normal)
        setImage(Image.x, for: .clear, state: .normal)
        
        if let textField = value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .none
            textField.backgroundColor = Color.gray1
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
