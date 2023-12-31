//
//  TrackerCardViewCell.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit

protocol TrackerCardViewCellDelegate: AnyObject {
    func dayCheckButtonTapped(viewModel: CellViewModel)
}

final class TrackerCardViewCell: UICollectionViewCell {

    weak var delegate: TrackerCardViewCellDelegate?

    //MARK: -Private Properties
    private let cardBackgroundView: UIView = {
        let cardBackgroundView = UIView()
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cardBackgroundView.layer.masksToBounds = true
        cardBackgroundView.layer.cornerRadius = 12
        return cardBackgroundView
    }()

    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        return emojiLabel
    }()

    private let taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.font = UIFont.systemFont(ofSize: 12)
        taskLabel.textColor = .white
        return taskLabel
    }()

    private let pinImage: UIImageView = {
        let pin = UIImageView()
        pin.image = UIImage(named: "Pin_image")
        pin.translatesAutoresizingMaskIntoConstraints = false
        pin.isHidden = false
        return pin
    }()

    private let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        dayLabel.textColor = .YPBlack
        return dayLabel
    }()

    private let dayCheckButton: UIButton = {
        let dayCheckButton = UIButton()
        dayCheckButton.translatesAutoresizingMaskIntoConstraints = false
        dayCheckButton.setTitle("", for: .normal)
        dayCheckButton.tintColor = .YPWhite
        dayCheckButton.layer.cornerRadius = 16
        dayCheckButton.layer.masksToBounds = true
        dayCheckButton.imageView?.contentMode = .scaleAspectFill
        dayCheckButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dayCheckButton.addTarget(nil, action: #selector(dayCheckButtonTapped(_:)), for: .touchUpInside)
        return dayCheckButton
    }()

    private var viewModel: CellViewModel?

    //MARK: -Public Methods
    func configCell(viewModel: CellViewModel) {
        taskLabel.text = viewModel.tracker.name
        emojiLabel.text = viewModel.tracker.emoji
        dayLabel.text = "\(viewModel.dayCounter) \(daysDeclension(for: viewModel.dayCounter))"
        cardBackgroundView.backgroundColor = viewModel.tracker.color
        dayCheckButton.backgroundColor = viewModel.tracker.color
        pinImage.isHidden = !viewModel.tracker.isPinned
        self.viewModel = viewModel
        dayCheckButtonState()
        dayCheckButtonIsEnabled()

        createCustomCell()
    }

    //MARK: - Private Methods
    private func createCustomCell() {
        addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(emojiLabel)
        cardBackgroundView.addSubview(taskLabel)
        cardBackgroundView.addSubview(pinImage)
        addSubview(dayLabel)
        addSubview(dayCheckButton)


        NSLayoutConstraint.activate([
            //Цветная подложка
            cardBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            cardBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            //Эмодзи
            emojiLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            pinImage.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            pinImage.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -4),
            //Лэйбл задачи
            taskLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -12),
            taskLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -12),
            //Кнопка подтверждения
            dayCheckButton.topAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: 8),
            dayCheckButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dayCheckButton.heightAnchor.constraint(equalToConstant: 34),
            dayCheckButton.widthAnchor.constraint(equalToConstant: 34),
            //Лэйбл количества дней
            dayLabel.centerYAnchor.constraint(equalTo: dayCheckButton.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
        dayCheckButtonState()
    }

    //для склонения дней в ячейке
    private func daysDeclension(for counter: Int) -> String {
        let formatString: String = NSLocalizedString("numberOfDays", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, counter)
        return resultString
    }

    //MARK: -Обновления состояния кнопки dayCheckButton в зависимости от значения свойства buttonIsChecked
    func dayCheckButtonState() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        var symbolImage: UIImage?
        guard let viewModel = viewModel else { return }
        if viewModel.buttonIsChecked {
            symbolImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
            dayCheckButton.layer.opacity = 0.3
        } else {
            symbolImage = UIImage(systemName: "plus", withConfiguration: symbolConfig)
            dayCheckButton.layer.opacity = 1.0
        }
        dayCheckButton.setImage(symbolImage, for: .normal)
    }

    //MARK: - Проверка и обновление состояния кнопки checkButton в зависимости от значения свойства buttonIsEnabled
    func dayCheckButtonIsEnabled() {
        guard let viewModel = viewModel,
              let selectedDate = TrackersViewController.selectedDate else { return }
        let currentDate = Date()
        let calendar = Calendar.current
        let isButtonEnabled = calendar.compare(currentDate, to: selectedDate, toGranularity: .day) != .orderedAscending

        if viewModel.buttonIsEnable && isButtonEnabled {
            dayCheckButton.isEnabled = true
            dayCheckButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(1)
        } else {
            dayCheckButton.isEnabled = false
            dayCheckButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(0.3)
        }
    }

    //MARK: -@OBJC Methods
    @objc private func dayCheckButtonTapped(_ sender: UIButton) {
        viewModel?.buttonIsChecked.toggle()
        dayCheckButtonState()
        guard let viewModel = viewModel else { return }
        delegate?.dayCheckButtonTapped(viewModel: viewModel)
    }
}
