//
//  EmojiHeader.swift
//  Tracker
//
//  Created by Максим on 23.07.2023.
//

import UIKit


//MARK: - Заголовок для CollectionViewEmoji
class EmojiHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
