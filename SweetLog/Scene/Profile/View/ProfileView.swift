//
//  ProfileView.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import UIKit

final class ProfileView: BaseView {
    let profileSectionView = ProfileSectionView()
    let containerView =  {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let userPostSementedVC = UserPostSegmentedViewController()
    
    override func configureHierarchy() {
        addSubviews([profileSectionView, containerView])
    }
    override func configureLayout() {
        profileSectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(profileSectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        super.configureView()
    }
}
