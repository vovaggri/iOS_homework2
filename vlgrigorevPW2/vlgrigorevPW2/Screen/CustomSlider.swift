import UIKit

enum Constants {
    static let titleSliderLeading: CGFloat = 20
    static let titleSliderTop: CGFloat = 10
    static let sliderLeading: CGFloat = 20
    static let sliderBottom: CGFloat = -10
    
    static let fatalError: String = "init(coder:) has not been implemented"
}

final class CustomSlider: UIView {
        var valueChanged: ((Double) -> Void)?
        
        var slider = UISlider()
        var titleView = UILabel()
        
        init(title: String, min: Double, max: Double) {
            super.init(frame: .zero)
            titleView.text = title
            slider.minimumValue = Float(min)
            slider.maximumValue = Float(max)
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            configureUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError(Constants.fatalError)
        }
        
        private func configureUI() {
            backgroundColor = .white
            translatesAutoresizingMaskIntoConstraints = false
            
            for view in [slider, titleView] {
                addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleSliderLeading),
                titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleSliderTop),
                
                slider.centerXAnchor.constraint(equalTo: centerXAnchor),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sliderLeading),
                slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.sliderBottom)
            ])
        }
        
        @objc
        private func sliderValueChanged() {
            valueChanged?(Double(slider.value))
        }
    }
