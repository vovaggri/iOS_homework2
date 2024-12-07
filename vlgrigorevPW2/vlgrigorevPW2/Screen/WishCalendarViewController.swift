import UIKit

final class WishCalendarViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Constants
    enum Constants {
        static let returnButtonName: String = "chevron.left"
        static let addButtonName: String = "plus.square"
        
        static let collectionViewNumber: Int = 0
        
        static let collectionTop: Double = 20
        
        static let extraBordersCollectionWidth: CGFloat = 10
        static let collectionHeight: CGFloat = 150
        
        static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        
        static let eventsKey: String = "eventsKey"
    }
    
    // MARK: - Variables
    var backgroundColor: UIColor?
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var events: [CalendarEventModel] = []
    private let defaults = UserDefaults.standard

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .systemYellow
        
        let returnButton = UIBarButtonItem(image: UIImage(systemName: Constants.returnButtonName), style: .plain, target: self, action: #selector(returnButtonPressed))
        let addButton = UIBarButtonItem(image: UIImage(systemName: Constants.addButtonName), style: .plain, target: self, action: #selector(addButtonPressed))
        
        navigationItem.leftBarButtonItem = returnButton
        navigationItem.rightBarButtonItem = addButton
        configureCollection()
        
        loadEvents()
    }
    
    // MARK: - Private functions
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backgroundColor ?? .systemYellow
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            layout.invalidateLayout()
        }
        
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.Constants.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.pinHorizontal(to: view)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.collectionTop)
        
    }
    
    private func saveEvents() {
        // Сохраняем события в UserDefaults
        if let encodedEvents = try? JSONEncoder().encode(events) {
            defaults.set(encodedEvents, forKey: Constants.eventsKey)
        }
    }
    
    private func loadEvents() {
        // Загружаем события из UserDefaults
        if let savedEventsData = defaults.data(forKey: Constants.eventsKey),
            let decodedEvents = try? JSONDecoder().decode([CalendarEventModel].self, from: savedEventsData) {
            events = decodedEvents
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private objc functions
    @objc private func returnButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let creationView = WishEventCreationView()
        creationView.delegate = self // Устанавливаем делегат
        creationView.backgroundColor = self.view.backgroundColor
        present(creationView, animated: true)
    }
}

// MARK: - WishEventCreationDelegate
extension WishCalendarViewController: WishEventCreationDelegate {
    func didSetEvent(_ event: CalendarEventModel) {
        print("Event added: \(event)")
        events.append(event)
        saveEvents()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.Constants.reuseIdentifier, for: indexPath) as? WishEventCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: events[indexPath.item])

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width - Constants.extraBordersCollectionWidth, height: Constants.collectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete an event", message: "Are you sure, that you want delete this event?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.events.remove(at: indexPath.row)
            self?.saveEvents()
            collectionView.deleteItems(at: [indexPath])
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
        
        print("Cell tapped at index \(indexPath.item)")
    }
}
