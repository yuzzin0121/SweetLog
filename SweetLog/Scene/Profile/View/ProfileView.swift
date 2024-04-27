//
//  ProfileView.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import UIKit

final class ProfileView: BaseView {
    let profileSectionView = ProfileSectionView()
    
    override func configureHierarchy() {
        addSubviews([profileSectionView])
    }
    override func configureLayout() {
        profileSectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
    }
    override func configureView() {
        super.configureView()
    }
}
