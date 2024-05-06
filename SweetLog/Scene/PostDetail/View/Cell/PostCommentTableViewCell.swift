//
//  PostCommentTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/26/24.
//

import UIKit
import RxSwift

final class PostCommentTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    let commentLabel = UILabel()
    let moreButton = UIButton()
    
    let commentMoreItemClicked = PublishSubject<Int>()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        profileImageView.image = Image.emptyProfileImage
        configureCell(comment: nil)
    }
    
    func configureCell(comment: Comment?) {
        guard let comment else { return }
        if let profileImageUrl = comment.creator.profileImage {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { [weak self] isSuccess in
                guard let self else { return }
                if !isSuccess {
                    profileImageView.image = Image.emptyProfileImage
                }
            }
        } else {
            profileImageView.image = Image.emptyProfileImage
        }
        
        nicknameLabel.text = comment.creator.nickname
        nicknameLabel.addCharacterSpacing()
        dateLabel.text = DateFormatterManager.shared.formattedUpdatedDate(comment.createdAt)
        commentLabel.text = comment.content
        commentLabel.addCharacterSpacing()
        
        moreButton.isHidden = comment.creator.userId != UserDefaultManager.shared.userId
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, nicknameLabel, dateLabel, commentLabel, moreButton])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(18)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.equalTo(13)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-12)
            make.height.equalTo(11)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(12)
        }
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(18)
            make.size.equalTo(16)
        }
    }
    override func configureView() {
        profileImageView.image = Image.emptyProfileImage
        
        nicknameLabel.design(font: .pretendard(size: 12, weight: .semiBold))
        dateLabel.design(font: .pretendard(size: 11, weight: .light))
        commentLabel.design(font: .pretendard(size: 15, weight: .regular), numberOfLines: 0)
        
        
        var moreConfig = UIButton.Configuration.plain()
        moreConfig.image = Image.moreVertical.resized(to: CGSize(width: 14, height: 14))
        moreButton.configuration = moreConfig
        configureMoreMenu()
    }
    
    private func configureMoreMenu() {
        moreButton.showsMenuAsPrimaryAction = true
        let actions = MoreItem.allCases.map { moreItem in
            UIAction(title: moreItem.title) { [weak self] _ in
                guard let self else { return }
                self.commentMoreItemClicked.onNext(moreItem.rawValue)
            }
        }
        
        moreButton.menu = UIMenu(children: actions)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
}
