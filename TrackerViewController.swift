//
//  ViewController.swift
//  Tracker
//
//  Created by Максим on 28.06.2023.
//

import UIKit

final class TrackerViewController: UIViewController {

    //MARK: - Private Properties
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .YPBlack
        button.setImage(UIImage(named: "Plus_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleHeader: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .YPBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .YPLightGrey
        label.layer.cornerRadius = 12
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.textColor = .YPBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.zPosition = 10
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_Ru")
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 12
        picker.tintColor = .YPBlue
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()

    private let searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .YPLightGrey
        textField.textColor = .YPBlack
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.YPGrey
        ]
        let attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: attributes
        )
        textField.attributedPlaceholder = attributedPlaceholder
        textField.delegate = self

        return textField
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.tintColor = .YPBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.isHidden = true
        return button
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Фильтры", for: .normal)
        button.backgroundColor = .YPBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.tintColor = .YPWhite
        button.addTarget(self, action: #selector(selectFilter), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

        private let placeholderView = PlaceholderView(
            title: "Что будем отслеживать?"
    )


    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        configureView()
        addElements()
        setupConstraints()
        configureCollectionView()
        updateDateLabelTitle(with: Date())

    }

    //MARK: - Helpers
    private func configureView() {
        view.backgroundColor = .YPWhite
        searchTextField.returnKeyType = .done
        filterButton.layer.zPosition = 2
    }

    private func reloadData() {
        //categories = dataManager.categories
        //dataChanged()
    }

    private func addElements() {
        view.addSubview(headerView)
        //view.addSubview(placeholderView)
        //view.addSubview(collectionView)
        view.addSubview(filterButton)

        headerView.addSubview(plusButton)
        headerView.addSubview(titleHeader)
        headerView.addSubview(dateLabel)
        headerView.addSubview(datePicker)
        headerView.addSubview(searchStackView)
        searchStackView.addArrangedSubview(searchTextField)
        //searchStackView.addArrangedSubview(cancelButton)
    }

    private func configureCollectionView() {

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // 13
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 138),

            plusButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 2),
            plusButton.topAnchor.constraint(equalTo: headerView.topAnchor),

            titleHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleHeader.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 21),

            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: titleHeader.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),

            datePicker.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            datePicker.centerYAnchor.constraint(equalTo: titleHeader.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),

            searchStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            searchStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            //placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // placeholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),

            //collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            // collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    //MARK: - Private Methods
    private func formatterDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }

    private func updateDateLabelTitle(with date: Date) {
        let dateString = formatterDate(from: date)
        dateLabel.text = dateString
    }

    @objc private func addTask() {
        //let createTrackerVC = CreateTrackerViewController()
        // createTrackerVC.updateDelegate = self
        // let navVC = UINavigationController(rootViewController: createTrackerVC)
        // present(navVC, animated: true)
    }

    @objc private func selectFilter() {
        print("Tapped filter")
    }

    @objc private func dateChanged() {
//        let calendar = Calendar.current
//        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
//
//        visibleCategories = categories.compactMap { category in
//            let trackers = category.trackers.filter { tracker in
//                tracker.schedule?.contains { weekDay in
//                    weekDay.numberValue == filterWeekday
//                } == true
//            }
//
//            if trackers.isEmpty {
//                return nil
//            }
//
//            return TrackerCategory(
//                title: category.title,
//                trackers: trackers
//            )
//        }
//
//            collectionView.reloadData()
        }

    }

//MARK: - Extension UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}



