//
//  PlaceholderView.swift
//  Tracker
//
//  Created by Максим on 29.06.2023.
//

import UIKit


final class PlaceholderView: UIView {
    private let placeholderView: UIImageView = {
        let placeholderView = UIImageView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.image = UIImage(named: "Image_placeholder")
        placeholderView.isHidden = false
        return placeholderView
    }()

    private let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.textColor = .YPBlack
        return placeholderLabel
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(placeholderView)
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderView.bottomAnchor, constant: 8)
        ])
    }
}



















//final class PlaceholderView: UIView {
//    private let emptyOnScreenLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let emptyOnScreenImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = Images.emptyOnScreenImage
//        return imageView
//    }()
//
//    init(title: String) {
//        self.emptyOnScreenLabel.text  = title
//        super.init(frame: .zero)
//
//        addViewsWithNoTAMIC(emptyOnScreenLabel)
//        addViewsWithNoTAMIC(emptyOnScreenImage)
//
//        NSLayoutConstraint.activate([
//           emptyOnScreenImage.centerXAnchor.constraint(equalTo: centerXAnchor),
//           emptyOnScreenImage.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            emptyOnScreenLabel.topAnchor.constraint(equalTo: emptyOnScreenImage.bottomAnchor, constant: 8),
//            emptyOnScreenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            emptyOnScreenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//       ])
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


