//
//  ViewController.swift
//  Tracker
//
//  Created by Максим on 28.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    enum PlaceholdersTypes {
        case noTrackers
        case notFoundTrackers
    }

    static var selectedDate: Date?

    //MARK: - Создаем поле с датой
    private let dateFormmater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = calendar
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()

    //MARK: - Создаем строку поиска
    private let searchStackView: UIStackView = {
        let searchStackView = UIStackView()
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.spacing = 8
        return searchStackView
    }()

    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Поиск"
        searchTextField.addTarget(nil, action: #selector(searchTextFieldEditingChanged), for: .editingChanged)
        return searchTextField
    }()

    private let cancelSearchButton: UIButton = {
        let cancelSearchButton = UIButton()
        cancelSearchButton.translatesAutoresizingMaskIntoConstraints = false
        cancelSearchButton.setTitle("Отменить", for: .normal)
        cancelSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelSearchButton.setTitleColor(.YPBlue, for: .normal)
        cancelSearchButton.addTarget(nil, action: #selector(cancelSearchButtonTapped), for: .touchUpInside)
        return cancelSearchButton
    }()

    //MARK: - Создаем коллекшинВью + плейсХолдер
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let imagePlaceholder: UIImageView = {
        let imagePlaceholder = UIImageView()
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.isHidden = false
        return imagePlaceholder
    }()

    private let textPlaceholder: UILabel = {
        let textPlaceholder = UILabel()
        textPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceholder.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textPlaceholder.textColor = .YPBlack
        textPlaceholder.isHidden = false
        return textPlaceholder
    }()

    //MARK: - Переменные трекера
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        configNavigationBar()
        configCollectionView()
        createLayout()
        searchTextField.delegate = self
        reloadPlaceholders(for: .noTrackers)
        datePickerValueChanged(datePicker)
    }

    //MARK: - Private Methods
    private func configNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addTrackerButtonTapped))
        let rightButton = UIBarButtonItem(customView: datePicker)
        leftButton.tintColor = .YPBlack

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(TrackerCardViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    private func createLayout() {
        [searchStackView, collectionView, imagePlaceholder, textPlaceholder].forEach{
            view.addSubview($0)}
        searchStackView.addArrangedSubview(searchTextField)

        NSLayoutConstraint.activate([
            //Поле поиска
            searchStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //Коллекция
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //Картинка-заглушка
            imagePlaceholder.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            imagePlaceholder.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            //Текст-заглушка
            textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8),
            //Кнопка отмена
            cancelSearchButton.widthAnchor.constraint(equalToConstant: 83)
        ])
    }

    private func reloadPlaceholders(for type: PlaceholdersTypes) {
        if visibleCategories.isEmpty {
            imagePlaceholder.isHidden = false
            textPlaceholder.isHidden = false
            switch type {
            case .noTrackers:
                imagePlaceholder.image = UIImage(named: "Image_placeholder")
                textPlaceholder.text = "Что будем отслеживать?"
            case .notFoundTrackers:
                imagePlaceholder.image = UIImage(named: "NotFound_placeholder")
                textPlaceholder.text = "Ничего не найдено"
            }
        } else {
            imagePlaceholder.isHidden = true
            textPlaceholder.isHidden = true
        }
    }

    private func configViewModel(for indexPath: IndexPath) -> CellViewModel {
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        let counter = completedTrackers.filter({$0.id == tracker.id}).count
        let trackerIsChecked = completedTrackers.contains(TrackerRecord(id: tracker.id, date: dateFormmater.string(from: currentDate)))
        _ = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day)
        let checkButtonEnable = true
        return CellViewModel(dayCounter: counter, buttonIsChecked: trackerIsChecked, buttonIsEnable: checkButtonEnable, tracker: tracker, indexPath: indexPath)
    }

    private func reloadVisibleCategories() {
        currentDate = datePicker.date
        let calendar = Calendar.current
        //Значение дня недели уменьшается на 1 для приведения его к правильному формату (0-понедельник, 1-вторник и т.д.).
        let filterDayOfWeek = calendar.component(.weekday, from: currentDate) - 1
        let filterText = (searchTextField.text ?? "").lowercased()

        visibleCategories = categories.compactMap { category in
            let trackers = category.trackerArray.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains(where: {$0 == filterDayOfWeek})
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(
                headerName: category.headerName,
                trackerArray: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholders(for: .noTrackers)
    }

    //MARK: - @OBJC Methods
    @objc private func addTrackerButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.delegate = self
        let newEventViewController = NewEventViewController()
        newEventViewController.delegate = self
        let NewTrackerTypeViewController = NewTrackerTypeViewController(newHabitViewController: newHabitViewController, newEventViewController: newEventViewController)
        let modalNavigationController = UINavigationController(rootViewController: NewTrackerTypeViewController)
        navigationController?.present(modalNavigationController, animated: true)
    }

    @objc private func datePickerValueChanged (_ sender: UIDatePicker) {
        TrackersViewController.selectedDate = sender.date
        reloadVisibleCategories()
    }

    @objc private func cancelSearchButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        datePickerValueChanged(datePicker)
        reloadPlaceholders(for: .noTrackers)
        cancelSearchButton.removeFromSuperview()
    }
}

//MARK: -UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
}

//MARK: -UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(item: 0, section: section)
        if visibleCategories[indexPath.section].trackerArray.count == 0 {
            return CGSizeZero
        }
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath)

        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

//MARK: -UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = visibleCategories[section].trackerArray.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCardViewCell
        cell.delegate = self
        let viewModel = configViewModel(for: indexPath)
        cell.configCell(viewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        headerView?.configHeader(text: visibleCategories[indexPath.section].headerName)
        return headerView ?? UICollectionReusableView()
    }
}

//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchStackView.addArrangedSubview(cancelSearchButton)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    @objc func searchTextFieldEditingChanged() {
        guard let textForSearching = searchTextField.text else { return }
        let weekDay = Calendar.current.component(.weekday, from: currentDate)-1
        let searchedCategories = searchText(in: categories, textForSearching: textForSearching, weekDay: weekDay)
        visibleCategories = searchedCategories
        reloadVisibleCategories()
        reloadPlaceholders(for: .notFoundTrackers)
    }

    private func searchText(in categories: [TrackerCategory], textForSearching: String, weekDay: Int) -> [TrackerCategory] {
        var searchedCategories: [TrackerCategory] = []

        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackerArray {
                let containsName = tracker.name.contains(textForSearching)
                let containsSchedule = tracker.schedule.contains(weekDay)
                if containsName && containsSchedule {
                    trackers.append(tracker)
                }
            }
            if !trackers.isEmpty {
                searchedCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
            }
        }
        return searchedCategories
    }
}

//MARK: -  NewHabitViewControllerDelegate
extension TrackersViewController: NewHabitViewControllerDelegate {
    func addNewHabit(_ trackerCategory: TrackerCategory) {
        var newCategories: [TrackerCategory] = []

        if let categoryIndex = categories.firstIndex(where: { $0.headerName == trackerCategory.headerName }) {
            for (index, category) in categories.enumerated() {
                var trackers = category.trackerArray
                if index == categoryIndex {
                    trackers.append(contentsOf: trackerCategory.trackerArray)
                }
                newCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
            }
        } else {
            newCategories = categories
            newCategories.append(trackerCategory)
            print(newCategories)
        }
        categories = newCategories
        datePickerValueChanged(datePicker)
        collectionView.reloadData()
    }
}

//MARK: - NewEventViewControllerDelegate
extension TrackersViewController: NewEventViewControllerDelegate {
    func addNewEvent(_ trackerCategory: TrackerCategory) {
        var newCategories: [TrackerCategory] = []

        if let categoryIndex = categories.firstIndex(where: { $0.headerName == trackerCategory.headerName }) {
            for (index, category) in categories.enumerated() {
                var trackers = category.trackerArray
                if index == categoryIndex {
                    trackers.append(contentsOf: trackerCategory.trackerArray)
                }
                newCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
            }
        } else {
            newCategories = categories
            newCategories.append(trackerCategory)
            print(newCategories)
        }
        categories = newCategories
        datePickerValueChanged(datePicker)
        collectionView.reloadData()
    }
}

//MARK: - TrackerCardViewCellDelegate
extension TrackersViewController: TrackerCardViewCellDelegate {
    func dayCheckButtonTapped(viewModel: CellViewModel) {
        if viewModel.buttonIsChecked {
            completedTrackers.insert(TrackerRecord(id: viewModel.tracker.id, date: dateFormmater.string(from: currentDate)))
        } else {
            completedTrackers.remove(TrackerRecord(id: viewModel.tracker.id, date: dateFormmater.string(from: currentDate)))
        }
        collectionView.reloadItems(at: [viewModel.indexPath])
    }
}



