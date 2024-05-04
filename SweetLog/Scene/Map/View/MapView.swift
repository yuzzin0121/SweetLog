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
    let placeSearchBar = SearchBar(placeholder: "키워드나 장소 이름을 검색해보세요 ex) 케이크, 성심당", backgroundColor: Color.white)
    let moveCurrentLoactionButton = UIButton()
    
    
    func setRegion(center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005,
                                    longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func configureHierarchy() {
        addSubviews([mapView, placeSearchBar, moveCurrentLoactionButton])
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
        moveCurrentLoactionButton.snp.makeConstraints { make in
            make.top.equalTo(placeSearchBar.snp.bottom).offset(40)
            make.trailing.equalToSuperview().inset(14)
            make.size.equalTo(40)
        }
    }
    override func configureView() {
        mapView.isPitchEnabled = true
        mapView.showsUserLocation = true
        
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
