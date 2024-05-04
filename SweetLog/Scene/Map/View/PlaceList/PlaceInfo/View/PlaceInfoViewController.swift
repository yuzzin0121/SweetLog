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
                                             placeItem: Observable.just(viewModel.placeItem))
        let output = viewModel.transform(input: input)
        
//        output.placeItem
//            .drive(with: self) { owner, placeInfo in
//                let (placeItem, meta) = placeInfo
//                owner.mainView.setPlaceItem(placeItem, meta: meta)
//            }
//            .disposed(by: disposeBag)
//        
//        output.postList
//            .drive(with: self) { owner, postList in
//                owner.mainView.setReviewCount(postList.count)
//            }
//            .disposed(by: disposeBag)
//
//        output.postList
//            .drive(mainView.collectionView.rx.items(cellIdentifier: ReviewCollectionViewCell.identifier, cellType: ReviewCollectionViewCell.self)) { index, postItem, cell in
//                cell.configureCell(postItem: postItem)
//            }
//            .disposed(by: disposeBag)
        
        output.placeInfoSection
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
