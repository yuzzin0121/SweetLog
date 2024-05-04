//
//  PlaceListView.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class PlaceListView: BaseView {
    let placeTableView = UITableView()
    let searchKeywordLabel = UILabel()
    
    let resultStackView = UIStackView()
    let markImageView = UIImageView()
    let resultCountLabel = UILabel()
    
    func setResult(resultCount: Int) {
        resultCountLabel.text = "\(resultCount)개"
        resultCountLabel.addCharacterSpacing()
        resultStackView.isHidden = false
    }
    
    func setSearchText(_ searchText: String) {
        searchKeywordLabel.text = searchText
    }
    
    override func configureHierarchy() {
        addSubviews([searchKeywordLabel, resultStackView, placeTableView])
        [markImageView, resultCountLabel].forEach {
            resultStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        searchKeywordLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.horizontalEdges.greaterThanOrEqualToSuperview().inset(12)
        }
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(searchKeywordLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        markImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        placeTableView.snp.makeConstraints { make in
            make.top.equalTo(resultStackView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        super.configureView()
        
        placeTableView.backgroundColor = .systemGray6
        placeTableView.separatorStyle = .none
        placeTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        placeTableView.rowHeight = 60
        placeTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        
        searchKeywordLabel.design(font: .pretendard(size: 18, weight: .bold), textAlignment: .center)
        resultStackView.design(axis: .horizontal)
        markImageView.image = Image.markFill
        markImageView.tintColor = Color.gray5
        resultCountLabel.design(textColor: Color.gray, font: .pretendard(size: 12, weight: .light))
        resultStackView.isHidden = true
    }
}
