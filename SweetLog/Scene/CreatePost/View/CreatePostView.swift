//
//  CreatePostView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class CreatePostView: BaseView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let placeInfoView = PlaceInfoView()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([placeInfoView])
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalTo(scrollView)
        }
        placeInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
    }
    override func configureView() {
        super.configureView()
    }
}
