//
//  FiltersCell.swift
//  Tracker
//
//  Created by Максим on 29.11.2023.
//

import UIKit

final class FiltersCell: UITableViewCell {

    // добавил название
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    // добавил галочку
    let checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.image = UIImage(systemName: "checkmark")
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        return checkmark
    }()

    static let reuseIdentifier = "FiltersCell"

//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        setupCell()
//    }

    // поменял на другой инит
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    // добавил функция по конфигурации ячейки
    func configureCell(titleText: String, checkmarkIsHidden: Bool) {
        title.text = titleText
        checkmark.isHidden = checkmarkIsHidden
    }

    func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPBlack
        detailTextLabel?.textColor = UIColor.YPGrey

        layoutMargins = .zero
        separatorInset = .init(top: 0, left: 16, bottom: 0, right: -16)

        [title, checkmark].forEach({ addSubview($0) })
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkmark.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            checkmark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
