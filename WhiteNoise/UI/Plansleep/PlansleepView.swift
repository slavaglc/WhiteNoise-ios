//
//  PlansleepView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

class PlansleepView: UIView {
    private enum ViewState {
        case sleep
        case wakeUp
    }
    
    private class Tags {
        static let buttonNext = 0
        static let buttonNextFinish = 1
        static let buttonSkip = 2
        static let buttonBack = 3
    }
    
    private var lastTime = [20, 30]
    private var viewState: ViewState = ViewState.sleep {
        didSet {
            if viewState == .wakeUp {
                lastTime[0] = picker.selectedRow(inComponent: 0)
                lastTime[1] = picker.selectedRow(inComponent: 1)
                
                label2.text = "When you wake up?"
                skipButton.setTitle("Back", for: .normal)
                nextButton.tag = Tags.buttonNextFinish
                skipButton.tag = Tags.buttonBack
                
                picker.selectRow(7, inComponent: 0, animated: false)
                picker.selectRow(30, inComponent: 1, animated: false)
                
                indicator.selectItem(pos: 1)
            } else if viewState == .sleep {
                label2.text = "What time you go to bed?"
                skipButton.setTitle("Skip", for: .normal)
                nextButton.tag = Tags.buttonNext
                skipButton.tag = Tags.buttonSkip
                
                picker.selectRow(lastTime[0], inComponent: 0, animated: false)
                picker.selectRow(lastTime[1], inComponent: 1, animated: false)
                
                indicator.selectItem(pos: 0)
            }
        }
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 22)
        view.text = "Plan your sleep"
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 254)
        
        return view
    }()
    
    private lazy var label2: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 18)
        view.text = "What time you go to bed?"
        view.textColor = .fromNormalRgb(red: 162, green: 171, blue: 241)
        
        return view
    }()

    private lazy var indicator: UIPageIndicatorView = {
        let view = UIPageIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // time picker
    private lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.selectRow(20, inComponent: 0, animated: false)
        view.selectRow(0, inComponent: 1, animated: false)
        
        return view
    }()
    
    // ':' for picker
    private lazy var labelForPicker: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Nunito-Bold", size: 42)
        view.text = ":"
        view.textColor = .fromNormalRgb(red: 162, green: 171, blue: 241)
        
        return view
    }()
    
    // bottom skip button
    private lazy var skipButton: UIButton = {
        let view = UIButton(type: .system)
        view.tag = Tags.buttonSkip
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Skip", for: .normal)
        view.setTitleColor(.fromNormalRgb(red: 220, green: 224, blue: 255), for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        view.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        
        return view
    }()
    
    // bottom next button
    private lazy var nextButton: UIButton = {
        let view = UIButton(type: .system)
        view.tag = Tags.buttonNext
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Next", for: .normal)
        view.setTitleColor(.fromNormalRgb(red: 220, green: 224, blue: 255), for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 238)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationsManager.shared.setEnabled(true)
        
        // add all views
        addSubview(label)
        addSubview(label2)
        addSubview(indicator)
        addSubview(picker)
        addSubview(labelForPicker)
        addSubview(skipButton)
        addSubview(nextButton)
        
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewDidAppear(_ animated: Bool) {
        removeAllViewsFromNavigation()
    }
    
    func didLayoutSubviews() {
        setSelectionIndicator()
    }
    
    @objc
    private func buttonDidTapped(sender: UIButton) {
        HapticManager.shared.notify(notificationType: .success)
        
        switch sender.tag {
        case Tags.buttonNext:
            
            let hour = picker.selectedRow(inComponent: .zero)
            let minute = picker.selectedRow(inComponent: 1)
            
            
            picker.changeAnimationByAlpha()
            label2.changeAnimationByAlpha(change: {
                self.viewState = .wakeUp
            })
            break
        case Tags.buttonNextFinish:
            StorageManager.shared
                .setTimes(
                    sleep: Time(hour: lastTime[0], minute: lastTime[1]),
                    wakeup: Time(hour: picker.selectedRow(inComponent: 0), minute: picker.selectedRow(inComponent: 1))
                )
            
            setReminder()
            viewController?.navigationController?.popViewController(animated: true)
            //viewController?.navigationController?.pushViewController(MixViewController(), animated: true)
            break
        case Tags.buttonSkip:
            viewController?.navigationController?.popViewController(animated: true)
            //viewController?.navigationController?.pushViewController(MixViewController(), animated: true)
            break
        case Tags.buttonBack:
            picker.changeAnimationByAlpha()
            label2.changeAnimationByAlpha(change: {
                self.viewState = .sleep
            })
            break
        default:
            break
        }
    }
    
    private func setReminder() {
        if let sleepTime = StorageManager.shared.getSleepTime() {
            let hour = sleepTime.hour
            let minute = sleepTime.minute
            NotificationsManager.shared.stop()
            NotificationsManager.shared.start(title: "Are you getting ready to bed?", body: "White Noise will help you!", hour: hour, minute: minute)
        }
    }
    
    private func setUpConstraint() {
        let topPadding = 10.0
        // label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topPadding),
            label.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // label2
        NSLayoutConstraint.activate([
            label2.leftAnchor.constraint(equalTo: label.leftAnchor),
            label2.topAnchor.constraint(equalTo: label.bottomAnchor),
            label2.widthAnchor.constraint(equalToConstant: 220),
            label2.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // indicator
        NSLayoutConstraint.activate([
            indicator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            indicator.topAnchor.constraint(equalTo: label.centerYAnchor, constant: -0),
            indicator.widthAnchor.constraint(equalToConstant: 40),
            indicator.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        // picker
        NSLayoutConstraint.activate([
            picker.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            picker.topAnchor.constraint(lessThanOrEqualTo: label2.bottomAnchor),
            picker.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            picker.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            picker.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // labelForPicker
        NSLayoutConstraint.activate([
            labelForPicker.leadingAnchor.constraint(equalTo: picker.safeAreaLayoutGuide.leadingAnchor),
            labelForPicker.topAnchor.constraint(equalTo: picker.topAnchor),
            labelForPicker.widthAnchor.constraint(equalTo: picker.widthAnchor),
            labelForPicker.bottomAnchor.constraint(equalTo: picker.bottomAnchor)
        ])
        
        // skip button
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            skipButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            skipButton.widthAnchor.constraint(equalToConstant: 90),
            skipButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // next button
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            nextButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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

// time picker delegate
extension PlansleepView: UIPickerViewDelegate {
    
}

// time picker data source
extension PlansleepView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // hour and minutes
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80.0 // item width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0 // item height
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // is hour component
            return 24 // hours in day
        }
        
        return 60 // minutes in hour
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        
        label.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        label.font = UIFont(name: "Nunito-Bold", size: 42)!
        label.text = "\(row)".count == 1 ? "0\(row)" : "\(row)"
        label.textColor = .fromNormalRgb(red: 220, green: 224, blue: 255)
        label.textAlignment = .center
        
        return label
    }
}
