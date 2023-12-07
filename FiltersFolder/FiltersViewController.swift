//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Максим on 29.11.2023.
//

import UIKit

//TODO: - Фильтр не реализован, не успеваю доделать
struct CellData {
    let title: String
    let identifier: String
}

enum FilterType: Int {
    case allTrackers = 0
    case todayTrackers
    case completed
    case notCompleted
}


protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filterType: FilterType)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: FiltersViewControllerDelegate?

    let cellDataArray = [
        CellData(title: "Все трекеры", identifier: "allTrackers"),
        CellData(title: "Трекеры на сегодня", identifier: "todayTrackers"),
        CellData(title: "Завершенные", identifier: "completedTrackers"),
        CellData(title: "Незавершенные", identifier: "incompleteTrackers")
    ]

    let currentFilterType: FilterType // добавил текущий фильтр

    private var customView: UIView = {
       let view = UIView()
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FiltersCell.self, forCellReuseIdentifier: FiltersCell.reuseIdentifier)
        return tableView
    }()

    // добавил инициализатор
    init(currentFilterType: FilterType) {
        self.currentFilterType = currentFilterType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Фильтры", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]

        createLayout()
    }

    func createLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 4 * 75)
        ])
    }
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.reuseIdentifier, for: indexPath) as? FiltersCell else { return UITableViewCell() }
//        cell.textLabel?.text = cellDataArray[indexPath.row].title
        let isCheckmarkHidden = currentFilterType.rawValue == indexPath.row ? false : true
        cell.configureCell(titleText: cellDataArray[indexPath.row].title, checkmarkIsHidden: isCheckmarkHidden) // поменял на вызов метода из FiltersCell
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = cellDataArray[indexPath.row].identifier
        switch cellIdentifier {
        case "allTrackers":
            delegate?.didSelectFilter(.allTrackers)
        case "todayTrackers":
            delegate?.didSelectFilter(.todayTrackers)
        case "completedTrackers":
            delegate?.didSelectFilter(.completed)
        case "incompleteTrackers":
            delegate?.didSelectFilter(.notCompleted)
        default:
            break
        }
        dismiss(animated: true)
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Настройка внешнего вида ячейки

        // Вычисляем, является ли ячейка первой или последней
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        if isFirstCell && isLastCell {
            // Ячейка одна в секции - закругляем все углы
            cell.contentView.layer.cornerRadius = 16
        } else if isFirstCell {
            // Первая ячейка в секции - закругляем верхние углы
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastCell {
            // Последняя ячейка в секции - закругляем нижние углы
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Прочие ячейки - без закругления
            cell.contentView.layer.cornerRadius = 0
            cell.contentView.layer.maskedCorners = []
        }
        cell.backgroundColor = .YPBackgroundDay // Прозрачный фон ячейки
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = .YPBlack // Цвет текста
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let availableWidth = tableView.bounds.width - leftPadding - rightPadding
        return availableWidth
    }
}
