//
//  UIView+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
