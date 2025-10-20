//
//  GradientView.swift
//  weather
//
//  Created by Einstein Nguyen on 10/19/25.
//

import UIKit

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var startColor: UIColor = .systemPurple
    private var endColor: UIColor = .systemPink

    init(frame: CGRect, startColor: UIColor, endColor: UIColor) {
        super.init(frame: frame)
        self.startColor = startColor
        self.endColor = endColor
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
