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
    let emptyMessageLabel = UILabel()
    
    func setEmpty(_ isEmpty: Bool) {
        emptyMessageLabel.isHidden = !isEmpty
    }
    
    func setResult(resultCount: Int) {
        resultCountLabel.text = "\(resultCount)개"
        resultCountLabel.addCharacterSpacing()
        resultStackView.isHidden = false
    }
    
    func setSearchText(_ searchText: String) {
        searchKeywordLabel.text = searchText
    }
    
    override func configureHierarchy() {
        addSubviews([searchKeywordLabel, resultStackView, placeTableView, emptyMessageLabel])
        [markImageView, resultCountLabel].forEach {
            resultStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        searchKeywordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
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
        emptyMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(resultStackView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    override func configureView() {
        super.configureView()
        
        placeTableView.backgroundColor = Color.white
        placeTableView.separatorStyle = .none
        placeTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        placeTableView.rowHeight = 64
        placeTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        
        searchKeywordLabel.design(font: .pretendard(size: 18, weight: .bold), textAlignment: .center)
        resultStackView.design(axis: .horizontal)
        markImageView.image = Image.markFill
        markImageView.tintColor = Color.gray5
        resultCountLabel.design(textColor: Color.gray, font: .pretendard(size: 12, weight: .light))
        resultStackView.isHidden = true
        
        emptyMessageLabel.design(text: "키워드 또는 장소를 검색해보세요", textColor: Color.gray, font: .pretendard(size: 16, weight: .semiBold), textAlignment: .center)
    }
}
