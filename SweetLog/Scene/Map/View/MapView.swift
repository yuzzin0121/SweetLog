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
    
    override func configureHierarchy() {
        addSubview(mapView)
    }
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        mapView.isPitchEnabled = true
        mapView.showsUserLocation = true
    }
}
