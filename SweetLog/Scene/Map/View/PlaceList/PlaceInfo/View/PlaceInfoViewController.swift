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
                                             reviewCellTapped: mainView.collectionView.rx.modelSelected(FetchPostItem.self).asObservable())
        let output = viewModel.transform(input: input)
        
        output.placeInfoSection
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.reviewCellTapped
            .drive(with: self) { owner, fetchPostItem in
                owner.showPostDetailVC(postId: fetchPostItem.postId)
            }
            .disposed(by: disposeBag)
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
            
            return headerView
        }
        )
    }
    
    override func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }

    override func loadView() {
        view = mainView
    }
}
