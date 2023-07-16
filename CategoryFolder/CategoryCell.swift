//
//  CategoryCell.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit


import UIKit

final class CategoryCell: UITableViewCell {

    static let reuseIdentifier = "CategoryCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPBlack

        layoutMargins = .zero
        separatorInset = .zero
    }
}
