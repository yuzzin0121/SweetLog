//
//  TagSearchView.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class TagSearchView: BaseView {
    let searchTextField = UISearchTextField()
    
    override func configureHierarchy() {
        
    }
    override func configureLayout() {
        
    }
    override func configureView() {
        super.configureView()
        
        backgroundColor = Color.backgroundGray
        searchTextField.layer.cornerRadius = 24
        searchTextField.clipsToBounds = true
        searchTextField.placeholder = "해시태그를 검색해보세요"
        searchTextField.backgroundColor = Color.gray1
    }
}
