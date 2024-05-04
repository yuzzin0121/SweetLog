//
//  MapView.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import UIKit
import MapKit

final class MapView: BaseView {
    let mapView = MKMapView()
    let placeSearchBar = SearchBar(placeholder: "키워드 또는 장소를 검색해보세요 ex) 케이크, 성심당", backgroundColor: Color.white)
    let refreshButton = UIButton()
    let moveCurrentLoactionButton = UIButton()
    
    
    
    func addAnnotation(placeItemList: [PlaceItem]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mapView.removeAnnotations(mapView.annotations)
        }
        for place in placeItemList {
            guard let lat = Double(place.y), let lon = Double(place.x) else { return }
            let annotation = PlaceAnnotation(title: place.placeName,
                                             coordinate: CLLocationCoordinate2D(latitude: lat,
                                                                                longitude: lon))
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005,
                                    longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func configureHierarchy() {
        addSubviews([mapView, refreshButton, placeSearchBar, moveCurrentLoactionButton])
    }
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        placeSearchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBar.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        moveCurrentLoactionButton.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBar.snp.bottom).offset(40)
            make.trailing.equalToSuperview().inset(14)
            make.size.equalTo(40)
        }
    }
    override func configureView() {
        mapView.isPitchEnabled = true
        mapView.showsUserLocation = true
        mapView.register(PlaceAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "PlaceAnnotationView")
        
        var refreshConfig = UIButton.Configuration.filled()
        refreshConfig.image = Image.refresh.resized(to: CGSize(width: 18, height: 18))
        var titleContainer = AttributeContainer()
        titleContainer.font = .pretendard(size: 14, weight: .medium)
        refreshConfig.title = "현 지도에서 찾기"
        refreshConfig.attributedTitle = AttributedString("현 지도에서 찾기", attributes: titleContainer)
        refreshConfig.cornerStyle = .capsule
        refreshConfig.imagePadding = 6
        refreshConfig.baseBackgroundColor = Color.brown
        refreshConfig.baseForegroundColor = Color.white
        refreshButton.configuration = refreshConfig
        
        var currentLocationConfig = UIButton.Configuration.filled()
        currentLocationConfig.image = Image.current
        currentLocationConfig.cornerStyle = .capsule
        currentLocationConfig.baseBackgroundColor = Color.white
        currentLocationConfig.baseForegroundColor = Color.black
        moveCurrentLoactionButton.configuration = currentLocationConfig
        moveCurrentLoactionButton.layer.shadowColor = Color.black.cgColor
        moveCurrentLoactionButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        moveCurrentLoactionButton.layer.shadowOpacity = 0.4
        moveCurrentLoactionButton.layer.shadowRadius = 2
    }
}
