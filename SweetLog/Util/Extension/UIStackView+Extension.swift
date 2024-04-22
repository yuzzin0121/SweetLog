//
//  UIStackView+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit

extension UIStackView {
    func design(axis: NSLayoutConstraint.Axis = .vertical,
                alignment: UIStackView.Alignment = .fill,
                distribution: UIStackView.Distribution = .fill,
                spacing: CGFloat = 4
    ) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
