import UIKit

final class WishStoringViewController: UIViewController, UITextViewDelegate {
    enum Constants {
        static let numnerOfRows: Int = 10
        static let tableOffset: Double = 60
        static let tableNumber: Int = 2
        static let tableSections: Int = 2
        static let tableCornerRadius: CGFloat = 20
        static let dismissButtonTextFont: CGFloat = 18
        static let dismissButtonTop: CGFloat = 10
        static let dismissButtonHeight: CGFloat = 40
        static let dismissButtonLeading: CGFloat = 20
        
        static let cellIdentifier: String = "cell"
        static let dismissButtonText: String = "Close"
        static let wishesKey: String = "savedWishes"
    }

    
    private let table: UITableView = UITableView(frame: .zero)
    @objc private let dismissButton: UIButton = UIButton(type: .system)
    private let defaults = UserDefaults.standard
    private var wishArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        loadUserSavedWishes()
        configureTable()
        configureDismissButton()
        
        table.delegate = self
    }
    
    private func saveUserWishes() {
        defaults.set(wishArray, forKey: Constants.wishesKey)
    }
    
    private func loadUserSavedWishes() {
        if let savedWishes = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = savedWishes
        }
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .red
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        // Используем кастомный метод pin(to:)
        table.pin(to: view, Constants.tableOffset)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.resuId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }
    
    // MARK: - Make dismissButton
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
    
    @objc private func dismissButtonPressed() {
        dismiss(animated: true)
    }
}

// MARK: - AddWishCell
class AddWishCell: UITableViewCell, UITextViewDelegate {
    
    static let reuseId: String = "AddWishCell"
    
    enum Constants {
        static let textBorderWidth: CGFloat = 1
        static let textCornerRadius: CGFloat = 10
        static let text: String =  "Type your wish..."
        static let textTop: CGFloat = 10
        static let textLeading: CGFloat = 10
        static let textTrailing: CGFloat = -10
        static let textHeight: CGFloat = 60
        
        static let addWishButtonTitle: String = "Add wish"
        static let addWishButtonCornerRadius: CGFloat = 10
        static let addWishButtonTop: CGFloat = 10
        static let addWishButtonBottom: CGFloat = -5
        static let addWishButtonHeight: CGFloat = 25
        static let addWishButtonWidth: CGFloat = 100
    }
    
    private let wishText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.green.cgColor
        textView.layer.borderWidth = Constants.textBorderWidth
        textView.layer.cornerRadius = Constants.textCornerRadius
        textView.text = Constants.text
        textView.textColor = .white
        return textView
    }()
    
    private let addWishButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(Constants.addWishButtonTitle, for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .systemGreen
        addButton.layer.cornerRadius = Constants.addWishButtonCornerRadius
        return addButton
    }()
    
    var addWish: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        selectionStyle = .default
        configureUI()
        wishText.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .white {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.text
            textView.textColor = .white
        }
    }
    
    private func configureUI() {
        configureWishText()
        configureAddWishButton()
    }
    
    private func configureWishText() {
        contentView.addSubview(wishText)
        wishText.backgroundColor = .gray
        
        wishText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wishText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.textTop),
            wishText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textLeading),
            wishText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.textTrailing)
        ])
        
        wishText.setHeight(Constants.textHeight)
    }
    
    private func configureAddWishButton() {
        contentView.addSubview(addWishButton)
        
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addWishButton.topAnchor.constraint(equalTo: wishText.bottomAnchor, constant: Constants.addWishButtonTop),
            addWishButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addWishButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.addWishButtonBottom)
        ])
        
        addWishButton.setHeight(Constants.addWishButtonHeight)
        addWishButton.setWidth(Constants.addWishButtonWidth)
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func addWishButtonPressed(_ sender: UIButton) {
        let wishTextView = wishText.text
        if let text = wishTextView, !text.isEmpty, text != Constants.text {
            addWish?(text)
            wishText.textColor = .white
            wishText.text = Constants.text
            wishText.resignFirstResponder()
        }
    }
}


// MARK: - WrittenWishCell
final class WrittenWishCell: UITableViewCell {
    static let resuId: String = "WrittenWishCell"
    private let wishLabel: UILabel = UILabel()
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
        
        static let fatalError: String = "init(coder:) has not been implemented"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pin(to: self, Constants.wrapOffsetV)
        wrap.pin(to: self, Constants.wrapOffsetH)
        
        wrap.addSubview(wishLabel)
        wishLabel.pin(to: wrap, Constants.wishLabelOffset)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.tableSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
            
            cell.addWish = { [weak self] newWish in
                self?.wishArray.append(newWish)
                self?.saveUserWishes()
                self?.table.reloadData()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.resuId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate, Make an alert delete
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let alert = UIAlertController(title: "Delete a wish", message: "Are you sure, that you want delete this wish", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.wishArray.remove(at: indexPath.row)
            self?.saveUserWishes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}



