//
//  TimerView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 06.07.2022.
//

import UIKit


final class TimerView: UIView {
    
   
    let minutesString = Time.getAllMinutesString()
    let minutes = Time.getAllMinutes()
    
    private weak var timerViewController: TimerViewController?
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 24)
        label.textColor = .white
        label.text = "Set timer"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "close_button_icon_hd"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeDisplay))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
//        view.selectRow(20, inComponent: 0, animated: false)
//        view.selectRow(0, inComponent: 1, animated: false)
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set timer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 0.9333333333, alpha: 1) //#5A6BEE
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(setTimerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setPrimarySettings()
        setupConstraints()
    }
    
    convenience init(viewController: TimerViewController) {
        self.init()
        timerViewController = viewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setTimerButtonTapped() {
        let row = picker.selectedRow(inComponent: .zero)
        let remainMinutes = minutes[row] * 60
        AudioManager.shared.setTimer(to: remainMinutes)
        print("Minutes to set:", minutes[row])
        print("Seconds to set:", remainMinutes)
        timerViewController?.closeDisplay()
    }
    
    @objc func closeDisplay() {
        timerViewController?.closeDisplay()
    }
    
    
    public func didLayoutSubviews() {
       setSelectionIndicator()
    }
    
    private func setPrimarySettings() {
        backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(closeButton)
        addSubview(headerStackView)
        addSubview(picker)
        addSubview(button)
        
    }
    
    private func setupConstraints() {
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        let buttonHeight = 60.0
        
        
        headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5)
            .isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        picker.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        picker.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: padding)
            .isActive = true
        picker.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
            .isActive = true
        
        button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
            .isActive = true
        button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding)
            .isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight)
            .isActive = true
        button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        button.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding)
            .isActive = true
        button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
            .isActive = true
        
    }
    
    private func setSelectionIndicator() {
        for i in 0..<picker.subviews.count {
            if i == 1 {
                let selectionIndicator = picker.subviews[i]
                let componentWidth = 250.0
                let rowHeight = picker.rowSize(forComponent: .zero).height
                selectionIndicator.layer.borderWidth = 3
                selectionIndicator.layer.cornerRadius = 17
                selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
                selectionIndicator.widthAnchor.constraint(equalToConstant: componentWidth)
                    .isActive = true
                selectionIndicator.centerYAnchor.constraint(equalTo: picker.centerYAnchor)
                    .isActive = true
                selectionIndicator.centerXAnchor.constraint(equalTo: picker.centerXAnchor)
                    .isActive = true
                selectionIndicator.heightAnchor.constraint(equalToConstant: rowHeight)
                    .isActive = true
                
                picker.subviews[i].layer.borderColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1).cgColor //#A2ABF1
            }
        }
    }
}

extension TimerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        minutesString.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        minutesString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

         var title = UILabel()
            if let view = view {
                title = view as! UILabel
            }
           title.font = UIFont(name: "Nunito-Bold", size: 48)
           title.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
           title.text =  minutesString[row]
           title.textAlignment = .center

       return title

       }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        100
    }
    
}
