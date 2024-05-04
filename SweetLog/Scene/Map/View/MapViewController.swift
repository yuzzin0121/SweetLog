//
//  MapViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import RxSwift
import CoreLocation
import FloatingPanel
import MapKit

final class MapViewController: BaseViewController, FloatingPanelControllerDelegate {
    let mainView = MapView()
    let viewModel = MapViewModel()
    
    var floatingPanelC: FloatingPanelController!
    let placeListVC = PlaceListViewController()
    let locationManager = CLLocationManager()
    let getCurrentLocations = PublishSubject<[CLLocation]>()
    let centerCoordinate = PublishSubject<CLLocationCoordinate2D>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setFloatingPanelC()
        setDelegate()
        checkDeviceLocationAuthorization()
    }
    
    override func bind() {
        let input = MapViewModel.Input(viewDidLoadTrigger: Observable.just(()),
                                       currentLocationButtonTapped: mainView.moveCurrentLoactionButton.rx.tap.asObservable(),
                                       getCurrentLocations: getCurrentLocations.asObservable(), 
                                       centerCoord: centerCoordinate.asObservable(),
                                       searchText: mainView.placeSearchBar.rx.text.orEmpty.asObservable(),
                                       searchButtonTapped: mainView.placeSearchBar.rx.searchButtonClicked.asObservable())
        let output = viewModel.transform(input: input)
        
        output.viewDidLoadTrigger
            .drive(with: self) { owner, _ in
                print("viewDidLoadTrigger")
            }
            .disposed(by: disposeBag)
        
        output.currentLocationButtonTapped
            .drive(with: self) { owner, _ in
                owner.checkDeviceLocationAuthorization()
            }
            .disposed(by: disposeBag)
        
        output.currentLocationCoord
            .drive(with: self) { owner, currentLocation in
                owner.mainView.setRegion(center: currentLocation)
                owner.locationManager.stopUpdatingLocation()
            }
            .disposed(by: disposeBag)
        
        output.placeResult
            .drive(with: self) { owner, placeResult in
                let (searchText, placeList) = placeResult
                owner.placeListVC.viewModel.searchText.accept(searchText)
                owner.placeListVC.viewModel.placeList.accept(placeList)
            }
            .disposed(by: disposeBag)
    }
    
    private func setFloatingPanelC() {
        floatingPanelC = FloatingPanelController()
        let nav = UINavigationController(rootViewController: placeListVC)
        floatingPanelC.set(contentViewController: nav)
        floatingPanelC.track(scrollView: placeListVC.mainView.placeTableView)
        floatingPanelC.addPanel(toParent: self)
        floatingPanelC.designPanel()
        floatingPanelC.show()
        floatingPanelC.layout = MyFloatingPanelLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setDelegate() {
        floatingPanelC.delegate = self
        locationManager.delegate = self
        mainView.mapView.delegate = self
    }
    
    override func loadView() {
        view = mainView
    }
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerCoordinate.onNext(mapView.centerCoordinate)
        let centerCoordinate = mapView.centerCoordinate
        print("Map center changed to: \(centerCoordinate.latitude), \(centerCoordinate.longitude)")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // 사용자의 위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getCurrentLocations.onNext(locations)
        
        locationManager.stopUpdatingLocation()
    }
    
    // 사용자의 위치를 가져오는데 실패한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showAlert(title: "위치 정보 이용",
                       message: "사용자의 위치를 가져오는데 실패했습니다. 위치 권한을 확인해주세요.",
                       actionHandler: nil)
    }
    
    // 4) 사용자 권한 상태가 바뀔 떄를 알려줌 - 변경된 후에 앱을 다시 켜도 감지를 한다
    // 거부했다가 설정에서 허용으로 바꾸거나, notDetermined에서 허용을 했거나 허용해서 위치를 갖고 오는 도중에 다시 설정에서 거부를 하거나
    // iOS14 이상...
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
}



// 위치 권한 관련 코드
extension MapViewController {
    // 1) 사용자에게 권한 요청을 하기 위해, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        print(#function)
        // UI와 직결되어있지 않은 부분은 다른 알바생에게 맡겨랑!
        DispatchQueue.global().async {
            // 타입 메서드로 구현되어있음⭐️
            if CLLocationManager.locationServicesEnabled() {
                // 현재 사용자의 위치 권한 상태 확인
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)   // 권한상태 전달
                }
            } else {
                self.showAlert(title: "위치 정보 이용",
                               message: "위치 서비스가 꺼져있어서, 위치 권한 요청을 할 수 없어요.",
                               actionHandler: nil)
            }
        }
    }
    
    // 2) 사용자 위치 권한 상태 확인 후, 권한 요청 (처음에 들어왔다면,
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        print(#function)
        switch status {
        case .notDetermined:    // 앱을 처음 켰을 때 아직 권한이 결정되지 않은 상태 (권한이 아직 뜨지 않은 상태) => 권한 문구 띄우기 or 한번만 허용을 클릭했을 때
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:           // 허용 안함 클릭했을 때
            showLocationSettingAlert()
        case .authorizedWhenInUse:  // 앱을 사용하는 동안 허용
            // 사용자가 허용했으면 locationManager를 통해 startUpdationgLocation() 메서드 실행 -> didUpdateLocation 메서드 실행
            locationManager.startUpdatingLocation()
        default:
            print("Error")
        }
    }
    
    // 3) 설정으로 이동해주는 기능이 있는 Alert
    func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세여")
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}


class MyFloatingPanelLayout: FloatingPanelLayout {

    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .tip
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.1, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
