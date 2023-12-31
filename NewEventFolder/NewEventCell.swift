//
//  NewEventCell.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit

final class NewEventCell: UITableViewCell {

    static let reuseIdentifier = "NewEventCell"

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .YPGrey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPBlack
        detailTextLabel?.textColor = UIColor.YPGrey

        layoutMargins = .zero
        separatorInset = .zero
        contentView.addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
