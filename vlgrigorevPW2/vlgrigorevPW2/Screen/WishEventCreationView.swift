import UIKit
import CoreData

// MARK: - Protocols
protocol WishEventCreationDelegate: AnyObject {
    func didSetEvent(_ event: CalendarEventModel)
}

final class WishEventCreationView: UIViewController {
    // MARK: - Enum
    enum Constants {
        static let dismissButtonText: String = "Close"
        static let dismissButtonTextFont: CGFloat = 18
        static let dismissButtonTop: CGFloat = 10
        static let dismissButtonHeight: CGFloat = 40
        static let dismissButtonLeading: CGFloat = 20
        
        static let titlePlaceholder: String = "Event Title"
        static let fieldRaduis: CGFloat = 10
        static let borderFieldWidth: CGFloat = 1
        static let heightField: Double = 50
        static let paddingViewWidth: CGFloat = 10
        
        static let roulettsSpacing: Double = 50
        
        static let descriptionPlaceholder: String = "Event Description"
        static let buttonTitle: String = "Save Event"
        static let verticalSpacing: CGFloat = 20
        static let padding: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 150
        static let buttonRadius: CGFloat = 20
    }
    
    // MARK: - Variables
    var backgroundColor: UIColor?
    weak var delegate: WishEventCreationDelegate?
    private let calendarManager: CalendarManaging = CalendarManager()
    
    @objc private let dismissButton: UIButton = UIButton(type: .system)
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDateRoulette = UIDatePicker()
    private let endDateRoulette = UIDatePicker()
    private let saveButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        configureDismissButton()
        configureTitleField()
        configureDesciptionField()
        configureStartDateRoulette()
        configureEndDateRoulette()
        
        configureSaveButton()
    }
    
    private func configureTitleField() {
        view.addSubview(titleField)
        titleField.placeholder = Constants.titlePlaceholder
        titleField.layer.borderWidth = Constants.borderFieldWidth
        titleField.layer.borderColor = UIColor.darkGray.cgColor
        titleField.layer.cornerRadius = Constants.fieldRaduis
        titleField.textColor = .black
        titleField.setHeight(Constants.heightField)
        titleField.pinTop(to: dismissButton.bottomAnchor, Constants.padding)
        // Добавляем отступ через пустое представление
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth, height: titleField.frame.height))
        titleField.leftView = paddingView
        titleField.pinLeft(to: view, Constants.padding)
        titleField.pinRight(to: view, Constants.padding)
        titleField.leftViewMode = .always
    }
    
    private func configureDesciptionField() {
        view.addSubview(descriptionField)
        descriptionField.placeholder = Constants.descriptionPlaceholder
        descriptionField.layer.borderWidth = Constants.borderFieldWidth
        descriptionField.layer.borderColor = UIColor.darkGray.cgColor
        descriptionField.layer.cornerRadius = Constants.fieldRaduis
        descriptionField.textColor = .black
        descriptionField.setHeight(Constants.heightField)
        descriptionField.pinTop(to: titleField.bottomAnchor, Constants.padding)
        // Добавляем отступ через пустое представление
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth, height: descriptionField.frame.height))
        descriptionField.leftView = paddingView
        descriptionField.pinLeft(to: view, Constants.padding)
        descriptionField.pinRight(to: view, Constants.padding)
        descriptionField.leftViewMode = .always
    }
    
    private func configureStartDateRoulette() {
        view.addSubview(startDateRoulette)
        startDateRoulette.datePickerMode = .dateAndTime
        startDateRoulette.timeZone = TimeZone.current  // Устанавливаем временную зону на локальную
        startDateRoulette.locale = Locale.current // Устанавливаем локаль устройства
        startDateRoulette.pinTop(to: descriptionField.bottomAnchor, Constants.padding)
        startDateRoulette.pinRight(to: view, Constants.padding)
    }
    
    private func configureEndDateRoulette() {
        view.addSubview(endDateRoulette)
        endDateRoulette.datePickerMode = .dateAndTime
        endDateRoulette.timeZone = TimeZone.current  // Устанавливаем временную зону на локальную
        endDateRoulette.locale = Locale.current // Устанавливаем локаль устройства
        endDateRoulette.pinTop(to: startDateRoulette, Constants.roulettsSpacing)
        endDateRoulette.pinRight(to: view, Constants.padding)
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.setTitle(Constants.buttonTitle, for: .normal)
        saveButton.setHeight(Constants.buttonHeight)
        saveButton.setWidth(Constants.buttonWidth)
        saveButton.pinCenterX(to: view)
        saveButton.pinCenterY(to: view)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Constants.buttonRadius
        
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.setTitleColor(.systemPink, for: .normal)
        dismissButton.setTitle(Constants.dismissButtonText, for: .normal)
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.dismissButtonTextFont)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.dismissButtonTop),
            dismissButton.heightAnchor.constraint(equalToConstant: Constants.dismissButtonHeight),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.dismissButtonLeading)
        ])
        
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Objc functions
    @objc private func saveButtonPressed(_ sender: UIButton) {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty else {
            return
        }
        
        // Проверка корректности дат
        if startDateRoulette.date >= endDateRoulette.date {
            showAlert(message: "Дата окончания должна быть позже даты начала.")
            return
        }
        
        let event = CalendarEventModel(title: title, description: description, startDate: startDateRoulette.date, endDate: endDateRoulette.date)
        
        if calendarManager.create(eventModel: event) {
            delegate?.didSetEvent(event)
            dismiss(animated: true, completion: nil)
        } else  {
            
        }
    }
    
    @objc private func dismissButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

