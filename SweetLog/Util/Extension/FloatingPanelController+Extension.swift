//
//  FloatingPanelController+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import Foundation
import FloatingPanel

extension FloatingPanelController {
    func designPanel() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        
        
        appearance.cornerRadius = 25
        appearance.backgroundColor = Color.white
        surfaceView.appearance = appearance
    }
}
