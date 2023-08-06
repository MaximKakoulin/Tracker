//
//  ColorHeader.swift
//  Tracker
//
//  Created by Максим on 23.07.2023.
//

import UIKit


//MARK: - Заголовок для CollectionViewColor
class ColorHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .blue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
