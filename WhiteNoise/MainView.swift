//
//  MainView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

class MainView: UIView {
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 22)
        view.text = "Plan your sleep"
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        
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
    
    // time picker
    private lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add all views
        addSubview(label)
        addSubview(label2)
        addSubview(picker)
        addSubview(labelForPicker)
        
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpConstraint() {
        // label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
        
        // picker
        NSLayoutConstraint.activate([
            picker.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            picker.topAnchor.constraint(equalTo: label2.bottomAnchor),
            picker.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            picker.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // labelForPicker
        NSLayoutConstraint.activate([
            labelForPicker.leftAnchor.constraint(equalTo: picker.safeAreaLayoutGuide.leftAnchor),
            labelForPicker.topAnchor.constraint(equalTo: picker.topAnchor),
            labelForPicker.widthAnchor.constraint(equalTo: picker.widthAnchor),
            labelForPicker.bottomAnchor.constraint(equalTo: picker.bottomAnchor)
        ])
    }
}

// time picker delegate
extension MainView: UIPickerViewDelegate {
    
}

// time picker data source
extension MainView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // hour and minutes
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80.0 // item width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0 // item height
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
        label.text = "\(row)"
        label.textColor = .fromNormalRgb(red: 220, green: 224, blue: 255)
        label.textAlignment = .center
        
        return label
    }
}
