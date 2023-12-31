//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Максим on 16.07.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didAddCategory(category: String)
}

final class NewCategoryViewController: UIViewController {

    //MARK: -Private Properties
    private let newCategoryTextField: UITextField = {
        let newCategoryTextField = UITextField()
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.backgroundColor = .YPBackgroundDay
        newCategoryTextField.textColor = .YPBlack
        newCategoryTextField.clearButtonMode = .whileEditing
        newCategoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: newCategoryTextField.frame.height))
        newCategoryTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.YPGrey as Any]
        newCategoryTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString(
                "newCategoryTextField", comment: ""), attributes: attributes)
        newCategoryTextField.layer.masksToBounds = true
        newCategoryTextField.layer.cornerRadius = 16
        return newCategoryTextField
    }()

    private let readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.setTitle(NSLocalizedString(
            "doneButton", comment: ""), for: .normal)
        readyButton.setTitleColor(.YPBlack, for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        readyButton.addTarget(nil, action: #selector(readyButtonTapped), for: .touchUpInside)
        return readyButton
    }()

    weak var delegate: NewCategoryViewControllerDelegate?

    private var trackerCategoryStore: TrackerCategoryStore
    private lazy var fetchedResultsController = { trackerCategoryStore.fetchResultControllerForCategory }()

    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite

        newCategoryTextField.delegate = self
        readyButton.isEnabled = false
        readyButton.backgroundColor = .YPGrey

        createNewCategoryLayout()
    }

    //MARK: -Private Methods
    private func createNewCategoryLayout() {
        navigationItem.title = NSLocalizedString(
            "newCategoryTitle", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true


        [newCategoryTextField, readyButton].forEach{
            view.addSubview($0)}

        NSLayoutConstraint.activate([
            //Новая категория
            newCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            //кнопка "готово"
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    @objc func readyButtonTapped() {
        let newCategory = TrackerCategory(headerName: newCategoryTextField.text ?? "", trackerArray: [])
        let success = trackerCategoryStore.createNewCategory(category: newCategory)
        if success {
            /// Обновление fetchedResultsController после создания новой категории
            do {
                try fetchedResultsController.performFetch()
            } catch {
                assertionFailure("An error occurred while fetching the updated data: \(error)")
            }
        }
        guard let category = newCategoryTextField.text else { return }
        delegate?.didAddCategory(category: category)
        navigationController?.popViewController(animated: true)
    }

}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           text.count >= 3 {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .YPBlack
            readyButton.setTitleColor(.YPWhite, for: .normal)
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .YPGrey
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// Закрывает клавиатуру при нажатии кнопки "Ввод"
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        /// Закрывает клавиатуру при нажатии на свободную область
        textField.resignFirstResponder()
    }
}
