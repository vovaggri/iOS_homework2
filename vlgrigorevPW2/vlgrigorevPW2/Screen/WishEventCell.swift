import UIKit

struct WishEventModel {
    var title: String
    var description: String
    var startDate: String
    var endDate: String
}

final class WishEventCell: UICollectionViewCell {
    enum Constants {
        static let startDateLabelText: String = "Start Date: "
        static let endDateLabelText: String = "End Date: "
        static let reuseIdentifier: String = "WishEventCell"
        
        static let offset: Double = 5
        static let cornerRadius: CGFloat = 5
        static let backgroundColor: UIColor = .white
        static let titleColor: UIColor = .black
        static let textColor: UIColor = .gray
        static let titleTop: Double = 10
        static let titleLeading: Double = 10
        static let descriptionTop: Double = 60
        static let textLeading: Double = 10
        static let dateTop: Double = 20
        static let titleFont: UIFont = .systemFont(ofSize: 25, weight: .bold)
        static let textFont: UIFont = .systemFont(ofSize: 18)
    }
    
    // MARK: - Variables
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell configuration
    func configure(with event: CalendarEventModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let formattedStartDate = formatter.string(from: event.startDate)
        let formattedEndDate = formatter.string(from: event.endDate)
        
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start Date: \(formattedStartDate)"
        endDateLabel.text = "End Date: \(formattedEndDate)"
    }
    
    // MARK: - UIConfiguration
    private func configureWrap() {
        addSubview(wrapView)
        
        wrapView.pin(to: self, Constants.offset)
        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.backgroundColor
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.textColor = Constants.titleColor
        titleLabel.pinTop(to: wrapView, Constants.titleTop)
        titleLabel.font = Constants.titleFont
        titleLabel.pinLeft(to: wrapView, Constants.titleLeading)
        titleLabel.pinRight(to: wrapView, Constants.titleLeading)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.textColor = Constants.textColor
        descriptionLabel.pinTop(to: titleLabel, Constants.descriptionTop)
        descriptionLabel.font = Constants.textFont
        descriptionLabel.pinLeft(to: wrapView, Constants.textLeading)
        descriptionLabel.pinRight(to: wrapView, Constants.textLeading)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.textColor = Constants.textColor
        startDateLabel.pinTop(to: descriptionLabel, Constants.dateTop)
        startDateLabel.font = Constants.textFont
        startDateLabel.pinLeft(to: wrapView, Constants.textLeading)
        startDateLabel.pinRight(to: wrapView, Constants.textLeading)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.textColor = Constants.textColor
        endDateLabel.pinTop(to: startDateLabel, Constants.dateTop)
        endDateLabel.font = Constants.textFont
        endDateLabel.pinLeft(to: wrapView, Constants.textLeading)
        endDateLabel.pinRight(to: wrapView, Constants.textLeading)
    }
}

