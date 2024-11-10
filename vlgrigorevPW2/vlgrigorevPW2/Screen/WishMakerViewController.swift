//
//  ViewController.swift
//  vlgrigorevPW2
//
//  Created by Vladimir Grigoryev on 28.10.2024.
//

import UIKit

class WishMakerViewController: UIViewController {
    
    enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -20
        static let stackLeading: CGFloat = 20
        
        static let titleFont: CGFloat = 32
        static let titleText: String = "WishMaker"
        static let titleLeading: CGFloat = 20
        static let titleTop: CGFloat = 30
        
        static let descriptionText: String = "There you can change a color)"
        static let descriptionFont: CGFloat = 18
        static let descriptionLeading: CGFloat = 20
        static let descriptionTop: CGFloat = 20
        static let toggleButtonTop: CGFloat = -40
        
        static let alpha: CGFloat = 1.0
        
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let addWishButtonHeight: CGFloat = 50
        static let addWishButtonBottom: CGFloat = 10
        static let addWishButtonSide: CGFloat = 20
        static let addWishButtonText: String = "My wishes"
        static let addWishButtonRaduis: CGFloat = 20
    }
    
    private let interactor: BusinessLogic
    private var stackView: UIStackView?
    private var toggleButton: UIButton?
    private let addWishButton: UIButton = UIButton(type: .system)
    
    required init?(interactor: BusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        interactor.LoadStart(Model.Start.Request())
    }

    private func configureUI() {
        configureTitle()
        configureAddWishButton()
        configureSliders()
    }
    
    func displayStart() {

    }
    
    func displayOther() {
        
    }
    
    // MARK: - Configure a text part
    private func configureTitle() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = Constants.titleText
        title.font = UIFont.boldSystemFont(ofSize: Constants.titleFont)
        title.textColor = UIColor().random()
        
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeading),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTop)
        ])
        
        configureDescriptions(title)
    }
    
    private func configureDescriptions(_ titleLabel: UILabel) {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = Constants.descriptionText
        description.font = UIFont.systemFont(ofSize: Constants.descriptionFont)
        description.textColor = UIColor().random()
        
        view.addSubview(description)
        NSLayoutConstraint.activate([
            description.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            description.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.descriptionLeading),
            description.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.descriptionTop)
        ])
    }
    
    // MARK: - Make a stack of sliders with toggleButton
    private func configureSliders() {
        let stack = UIStackView();
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        
        for slider in [sliderRed, sliderBlue, sliderGreen] {
            stack.addArrangedSubview(slider)
        }
        
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("Hide sliders", for: .normal)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleButton)
        
        toggleButton.addTarget(self, action: #selector(toggleSliders), for: .touchUpInside)
        
        self.stackView = stack
        self.toggleButton = toggleButton
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            stack.bottomAnchor.constraint(equalTo: addWishButton.topAnchor, constant: Constants.stackBottom),
            
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.topAnchor.constraint(equalTo: stack.topAnchor, constant: Constants.toggleButtonTop)
        ])
        
        sliderRed.valueChanged = { [weak self] value in
            guard let self = self else {return}
            let red = CGFloat(value)
            let blue = CGFloat(sliderBlue.slider.value)
            let green = CGFloat(sliderGreen.slider.value)
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: Constants.alpha)
        }
        
        sliderBlue.valueChanged = { [weak self] value in
            guard let self = self else {return}
            let red = CGFloat(sliderRed.slider.value)
            let blue = CGFloat(value)
            let green = CGFloat(sliderGreen.slider.value)
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: Constants.alpha)
        }
        
        sliderGreen.valueChanged = { [weak self] value in
            guard let self = self else {return}
            let red = CGFloat(sliderRed.slider.value)
            let blue = CGFloat(sliderBlue.slider.value)
            let green = CGFloat(value)
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: Constants.alpha)
        }
    }
    
    @objc private func toggleSliders() {
        guard let stack = stackView, let button = toggleButton else { return }
        
        stack.isHidden.toggle()
        button.setTitle(stack.isHidden ? "Show sliders" : "Hide sliders", for: .normal)
    }
    
    // MARK: - Make AddWishButton
    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addWishButton.heightAnchor.constraint(equalToConstant: Constants.addWishButtonHeight),
            addWishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.addWishButtonSide),
            addWishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.addWishButtonSide),
            addWishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.addWishButtonBottom)
        ])
        
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.addWishButtonText, for: .normal)
        
        addWishButton.layer.cornerRadius = Constants.addWishButtonRaduis
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func addWishButtonPressed() {
        present(WishStoringViewController(), animated: true)
    }
}

