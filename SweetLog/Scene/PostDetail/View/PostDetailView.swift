//
//  PostDetailView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostDetailView: BaseView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let commentBackgroundView = UIView()
    let commentTextField = UITextField()
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(commentBackgroundView)
        commentBackgroundView.addSubview(commentTextField)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(commentBackgroundView.snp.top)
        }
        commentBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        commentTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        super.configureView()
        tableView.backgroundColor = Color.white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0   // sticky header 해제
        
        tableView.register(PostDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: PostDetailHeaderView.identifier)
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: PostCommentTableViewCell.identifier)
        
        commentBackgroundView.backgroundColor = Color.white
        commentTextField.backgroundColor = Color.gray1
        commentTextField.placeholder = "댓글 남기기"
        commentTextField.attributedPlaceholder = NSAttributedString(string: "댓글 남기기", attributes: [NSAttributedString.Key.font:UIFont(name: "Pretendard-Regular", size: 14)!])
        commentTextField.addLeftPadding()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.commentTextField.layer.cornerRadius = self.commentTextField.frame.height / 2
        }
        commentBackgroundView.layer.addBorder([.top], color: Color.gray, width: 0.5)
    }
}

