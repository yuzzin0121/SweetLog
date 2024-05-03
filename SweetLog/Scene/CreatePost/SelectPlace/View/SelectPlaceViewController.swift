//
//  SelectPlaceViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit

final class SelectPlaceViewController: BaseViewController {
    let mainView = SelectPlaceView()
    
    let viewModel = SelectPlaceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = SelectPlaceViewModel.Input(searchButtonTap: mainView.searchBar.rx.searchButtonClicked,
                                               searchText: mainView.searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.placeList
            .drive(mainView.placeCollectionView.rx.items(cellIdentifier: PlaceCollectionViewCell.identifier, cellType: PlaceCollectionViewCell.self)) { index, item, cell in
                cell.configureCell(item)
            }
            .disposed(by: disposeBag)
        
        
        mainView.placeCollectionView.rx.modelSelected(PlaceItem.self)
            .bind(with: self) { owner, placeItem in
                owner.showCreatePostVC(placeItem: placeItem)
            }
            .disposed(by: disposeBag)
    }
    
    private func showCreatePostVC(placeItem: PlaceItem) {
        let createPostVC = CreatePostViewController(placeItem: placeItem)
        navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(view.frame.width - 40, 60)
        layout.scrollDirection = .vertical
        mainView.placeCollectionView.collectionViewLayout = layout
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "후기 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }

}
