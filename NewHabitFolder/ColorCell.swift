//
//  ColorCell.swift
//  Tracker
//
//  Created by Максим on 23.07.2023.
//


import UIKit

final class ColorViewCell: UICollectionViewCell {
    let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


