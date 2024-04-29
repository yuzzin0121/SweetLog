//
//  UserPostSegmentedViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit
import Tabman
import Pageboy
import RxSwift

class UserPostSegmentedViewController: TabmanViewController {
    let tabView = {
        let view = UIView()
        view.backgroundColor = Color.white
        return view
    }()
    
    var viewControllers: [UIViewController] = []
    let tabTitles = ["후기", "좋아요"]
    var isMyProfile: Bool?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureHierachy()
        configureLayout()
        addViewControllers()
        createBar()
        setDelegate()
    }
    
    private func setDelegate() {
        dataSource = self
    }
    
    private func configureHierachy() {
        view.addSubview(tabView)
    }
    
    private func configureLayout() {
        tabView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view)
            make.height.equalTo(48)
        }
    }
    
    private func addViewControllers() {
        let myPostVC = UserPostViewController()
        myPostVC.viewModel.postType = .myPost
        
        guard let userId, let isMyProfile else  { return }
        
        myPostVC.viewModel.isMyPofile = isMyProfile
        myPostVC.viewModel.userId = userId
        
        if isMyProfile {
            let likePostVC = UserPostViewController()
            likePostVC.viewModel.isMyPofile = isMyProfile
            likePostVC.viewModel.userId = userId
            likePostVC.viewModel.postType = .like
            viewControllers.append(contentsOf: [myPostVC, likePostVC])
        } else {
            viewControllers.append(myPostVC)
        }
    }
    
    func createBar() {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.buttons.customize { (button) in
            button.tintColor = Color.gray
            button.font = .pretendard(size: 16, weight: .light)
            button.selectedFont = .pretendard(size: 16, weight: .bold)
            button.selectedTintColor = Color.black
        }
        bar.indicator.weight = .custom(value: 0)
        bar.indicator.tintColor = Color.black
        bar.indicator.overscrollBehavior = .compress
//        bar.layout.interButtonSpacing = 35 // 버튼 사이 간격
        bar.layout.contentMode = .fit
        
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
}


extension UserPostSegmentedViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = tabTitles[index]
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    
}
