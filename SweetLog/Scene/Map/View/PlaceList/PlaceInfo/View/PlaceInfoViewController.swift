//
//  PlaceInfoViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PlaceInfoViewController: BaseViewController {
    let mainView = PlaceDetailInfoView()
    let viewModel: PlaceInfoViewModel
    let callButtonTapped = PublishSubject<String>()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<PlaceInfoSection>!
    
    init(placeItem: PlaceItem) {
        viewModel = PlaceInfoViewModel(placeItem: placeItem)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        configureCollectionViewDataSource()
        
        let input = PlaceInfoViewModel.Input(viewDidLoadTrigger: Observable.just(()),
                                             placeItem: Observable.just(viewModel.placeItem), 
                                             reviewCellTapped: mainView.collectionView.rx.modelSelected(FetchPostItem.self).asObservable(),
                                             callButtonTapped: callButtonTapped.asObservable())
        let output = viewModel.transform(input: input)
        
        output.placeInfoSection
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.placeInfoSection
            .bind(with: self) { owner, placeInfoSection in
                guard let placeInfoSection = placeInfoSection.first else { return }
                if placeInfoSection.items.isEmpty {
                    owner.mainView.setEmptyLabelHidden(false)
                } else {
                    owner.mainView.setEmptyLabelHidden(true)
                }
            }
            .disposed(by: disposeBag)
        
        output.reviewCellTapped
            .drive(with: self) { owner, fetchPostItem in
                owner.showPostDetailVC(postId: fetchPostItem.postId)
            }
            .disposed(by: disposeBag)
        
        output.callButtonTapped
            .drive(with: self) { owner, phone in
                owner.callPhone(phone: phone)
            }
            .disposed(by: disposeBag)
    }
    
    private func callPhone(phone: String) {
        guard let number = URL(string: "tel://\(phone)") else { return }
        UIApplication.shared.open(number)
    }
    
    private func showPostDetailVC(postId: String) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.viewModel.postId = postId
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<PlaceInfoSection>(configureCell: { dataSource, collectionView, indexPath, postItem in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(postItem: postItem)
            
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, string, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewHeaderCollectionReusableView.identifier, for: indexPath) as? ReviewHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            let placeItem = dataSource.sectionModels[indexPath.section].header
            let postCount = dataSource.sectionModels[indexPath.section].items.count
            let meta = dataSource.sectionModels[indexPath.section].meta
            
            headerView.setReviewCount(postCount)
            headerView.setPlaceItem(placeItem, meta: meta)
            headerView.callButton.rx.tap
                .subscribe(with: self) { owner, _ in
                    owner.callButtonTapped.onNext(placeItem.phone)
                }
                .disposed(by: headerView.disposeBag)
            
            return headerView
        })
    }
    
    override func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }

    override func loadView() {
        view = mainView
    }
}
