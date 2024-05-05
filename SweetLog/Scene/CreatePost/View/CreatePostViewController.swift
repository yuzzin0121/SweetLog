//
//  CreatePostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit
import PhotosUI
import RxSwift

final class CreatePostViewController: BaseViewController {
    private let mainView = CreatePostView()
    private var menuChildren: [UIMenuElement] = []
    let viewModel: CreatePostViewModel
    let reviewText = PublishSubject<String>()
    var imageDataList: [Data] = [] {
        didSet {
            dataSubject.onNext(imageDataList)
        }
    }
    let dataSubject: BehaviorSubject<[Data]> = BehaviorSubject(value: [])
    
    init(placeItem: PlaceItem, postItem: FetchPostItem?, cuMode: CUMode) {
        viewModel = CreatePostViewModel(placeItem: placeItem, cuMode: cuMode)
        viewModel.postItem.accept(postItem)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setAction()
        setData()
    }
    
    override func bind() {
        let starValue = PublishSubject<Int>()
        let removeTag = PublishSubject<Int>()
        
        for button in mainView.buttonList {
            button.rx.tap
                .subscribe(with: self) { owner, _ in
                    starValue.onNext(button.tag)
                }
                .disposed(by: disposeBag)
        }
        
        
        let input = CreatePostViewModel.Input(viewDidLoadTrigger: Observable.just(()), 
                                              editPostItem: Observable.just(viewModel.postItem.value),
                                              categoryString: mainView.selectedCategorySubject.asObserver(),
                                              starValue: starValue.asObserver(),
                                              reviewText: reviewText.asObserver(),
                                              tagText: mainView.tagTextField.rx.text.orEmpty.asObservable(),
                                              tagTextFieldEditDone: mainView.tagTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(), 
                                              removeTag: removeTag.asObservable(),
                                              imageDataList: dataSubject.asObserver(),
                                              createPostButtonTapped: mainView.createButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        if viewModel.cuMode == .create {
            starValue.onNext(5)
        }
        
   
        output.starButtonTapped
            .debug()
            .drive(with: self) { owner, tag in
                print("starButtonTapped")
                owner.mainView.selectStarButton(tag)
            }
            .disposed(by: disposeBag)
        
        // 추가한 이미지 collectionView에 반영
        output.imageDataList
            .drive(mainView.photoCollectionView.rx.items(cellIdentifier: PhotoCollectionViewCell.identifier, cellType: PhotoCollectionViewCell.self)) { index, data, cell in
                cell.configureCell(data: data)
            }
            .disposed(by: disposeBag)
        
        output.reviewText
            .drive(with: self) { owner, reviewText in
                owner.mainView.setReviewText(reviewText)
            }
            .disposed(by: disposeBag)
        
        output.tagTextToEmpty
            .drive(with: self) { owner, _ in
                owner.mainView.setTagTextFieldEmpty()
            }
            .disposed(by: disposeBag)
        
        output.tagList
            .drive(mainView.tagCollectionView.rx.items(cellIdentifier: TagCollectionViewCell.identifier, cellType: TagCollectionViewCell.self)) { index, data, cell in
                cell.removeButton.tag = index
                cell.configureCell(tagText: data)
                cell.removeButton.rx.tap
                    .asDriver()
                    .drive(with: self) { owner, _ in
                        removeTag.onNext(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.tagError
            .drive(with: self) { owner, error in
                owner.showAlert(title: "태그 에러", message: error, actionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        output.createValid
            .drive(with: self) { owner, isValid in
                owner.mainView.setCreateButtonStatus(isValid)
            }
            .disposed(by: disposeBag)
        
        output.createPostSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.successPost()
            }
            .disposed(by: disposeBag)
    }
    
    private func successPost() {
        guard let viewControllerStack = navigationController?.viewControllers else { return }
        for viewController in viewControllerStack {
            if let homeVC = viewController as? HomeViewController {
                navigationController?.popToViewController(homeVC, animated: true)
            }
        }
    }
    
    private func setDelegate() {
        mainView.textView.delegate = self
    }
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddPhotoImageViewTapped))
        mainView.addPhotoImageView.isUserInteractionEnabled = true
        mainView.addPhotoImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func AddPhotoImageViewTapped() {
        print(#function)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // 선택한 장소 뷰에 반영
    private func setData() {
        mainView.placeInfoView.addressLabel.text = viewModel.placeItem.address
        mainView.placeInfoView.placeNameLabel.text = viewModel.placeItem.placeName
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 8
        mainView.photoCollectionView.collectionViewLayout = layout
    }
    
    override func configureNavigationItem() {
        navigationItem.title = viewModel.cuMode == .create ? "후기 작성" : "후기 수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.createButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
    
    override func loadView() {
        view = mainView
    }

}

// MARK: - UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    // textView에 focus를 얻는 경우 발생
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.contentTextViewPlaceholder {
            textView.textColor = Color.black
            textView.text = ""
        }
    }
    
    // textView에 focus를 잃는 경우 발생
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = viewModel.contentTextViewPlaceholder
            textView.textColor = Color.gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reviewText.onNext(textView.text)
    }
}


// MARK: - 이미지 추가 delegate 설정
extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if !(results.isEmpty) {
            for result in results {
                
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            guard let data = image.jpegData(compressionQuality: 0.4) else { return }
                            self.imageDataList.append(data)
                        }
                        
                        if error != nil {
                            return
                        }
                    }
                } else {
                    print("이미지 가져오기 실패")
                }
            }
        } else  {
            picker.dismiss(animated: true)
            return
        }
    }
}
