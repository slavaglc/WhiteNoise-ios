//
//  PaywallView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 19.04.2022.
//

import UIKit
import StoreKit


final class PaywallView: UIView {
//    private enum SubSelect {
//        case YEAR
//        case MONTH
//    }
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "PaywallBackground")
        
        return view
    }()
    
    private lazy var closeBtn: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "CloseButton")
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var textImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "PaywallText")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var subButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 255)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 220, green: 224, blue: 224), for: .normal)
        view.setTitle("Try Free & Subscribe", for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 22)
        view.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var sub1Button: UIButton = {
        let view = UIButton(type: .system)
        let buttonTitle = "     Yearly - 3 Day Trial Free\n     $YEARLY_PRICE$ / Year"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 201, green: 162, blue: 241)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
        view.setTitle(buttonTitle, for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.contentHorizontalAlignment = .left
        view.titleLabel?.font = UIFont(name: "Nunito-Medium", size: 14)
        view.tag = 0
        view.addTarget(self, action: #selector(selectSub), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var sub2Button: UIButton = {
        let view = UIButton(type: .system)
        let buttonTitle = "     Monthly\n     $MONTHLY_PRICE$ / Month"
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 201, green: 162, blue: 241)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
        view.setTitle("     Monthly\n     $MONTHLY_PRICE$ / Month", for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.contentHorizontalAlignment = .left
        view.titleLabel?.font = UIFont(name: "Nunito-Medium", size: 14)
        view.tag = 1
        view.addTarget(self, action: #selector(selectSub), for: .touchUpInside)
        
        return view
    }()
    
    private var subSelect: PremiumSubscribe = .yearly {
        didSet {
            if(subSelect == .yearly) {
                sub2Button.setTitleColor(UIColor.fromNormalRgb(red: 162, green: 171, blue: 241), for: .normal)
                sub2Button.layer.borderWidth = 1
                sub2Button.layer.borderColor = UIColor.fromNormalRgb(red: 162, green: 171, blue: 241).cgColor
                sub2Button.backgroundColor = .clear
                
                UIView.animate(withDuration: 0.3) {
                    self.sub1Button.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
                    self.sub1Button.layer.borderWidth = 0
                    self.sub1Button.layer.borderColor = UIColor.clear.cgColor
                    self.sub1Button.backgroundColor = UIColor.fromNormalRgb(red: 201, green: 162, blue: 241)
                }
            } else {
                sub1Button.setTitleColor(UIColor.fromNormalRgb(red: 162, green: 171, blue: 241), for: .normal)
                sub1Button.layer.borderWidth = 1
                sub1Button.layer.borderColor = UIColor.fromNormalRgb(red: 162, green: 171, blue: 241).cgColor
                sub1Button.backgroundColor = .clear
                
                UIView.animate(withDuration: 0.3) {
                    self.sub2Button.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
                    self.sub2Button.layer.borderWidth = 0
                    self.sub2Button.layer.borderColor = UIColor.clear.cgColor
                    self.sub2Button.backgroundColor = UIColor.fromNormalRgb(red: 201, green: 162, blue: 241)
                }
            }
        }
    }
    
    private var isFirstLaunch: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(backgroundImage)
        addSubview(textImage)
        addSubview(subButton)
        addSubview(sub1Button)
        addSubview(sub2Button)
        addSubview(closeBtn)
//        viewController?.navigationController?.view.addSubview(closeBtn)
//        
//        let price1 = PremiumManager.shared.getProducts()[0].displayPrice
//        let price2 = PremiumManager.shared.getProducts()[1].displayPrice
//        
//        sub2Button.setTitle(sub2Button.currentTitle!.replacingOccurrences(of: "{}", with: price1), for: .normal)
//        
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(isFirstLaunch: Bool = false) {
        self.init()
        self.isFirstLaunch = isFirstLaunch
    }
    
    func willAppear(_ animated: Bool) {
        subSelect = .yearly
        setPrices()
    }
    
    func didAppear(_ animated: Bool) {
        configureExistingSubscriptions()
        removeAllViewsFromNavigation()
    }
    
    private func setUpConstraints() {
        // closeBtn
        let topPadding = 10.0
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topPadding),
            closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeBtn.widthAnchor.constraint(equalToConstant: 40),
            closeBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // backgroundImage
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // textImage
        let deviceName = UIDevice.modelName
        let textImagePadding = (deviceName == "iPod9,1" || deviceName == "Simulator iPod touch (7th generation)") ? -30.0 : 64.0
        NSLayoutConstraint.activate([
            textImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: textImagePadding),
            textImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        // subButton
        NSLayoutConstraint.activate([
            subButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            subButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            subButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            subButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // sub2Button
        NSLayoutConstraint.activate([
            sub2Button.bottomAnchor.constraint(equalTo: subButton.topAnchor, constant: -16),
            sub2Button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            sub2Button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            sub2Button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // sub1Button
        NSLayoutConstraint.activate([
            sub1Button.bottomAnchor.constraint(equalTo: sub2Button.topAnchor, constant: -12),
            sub1Button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            sub1Button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            sub1Button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func purchaseTapped(view: UIView) {
        PremiumManager.shared.purchase(premiumSubscribe: subSelect) { [weak self] result in
            switch result {
            case .success(_):
                PremiumManager.shared.refreshEntities()
                self?.closeView()
//                self?.configureExistingSubscriptions()
                
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        }
    }
    
    @objc
    private func closeView() {
        if isFirstLaunch {
            let mixVC = MixViewController()
            viewController?.show(mixVC, sender: nil)
        } else {
        viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func selectSub(view: UIButton) {
        subSelect = view.tag == 0 ? .yearly : .monthly
    }
    
    private func setPrices() {
        let priceYearly = PremiumManager.shared.getPrice(for: .yearly) ?? "Not avaible"
        let priceMonthly = PremiumManager.shared.getPrice(for: .monthly) ?? "Not availbe"
        
        sub1Button.setTitle(sub1Button.currentTitle?.replacingOccurrences(of: "$YEARLY_PRICE$", with: priceYearly), for: .normal)
        sub2Button.setTitle(sub2Button.currentTitle?.replacingOccurrences(of: "$MONTHLY_PRICE$", with: priceMonthly), for: .normal)
    }
    
    private func configureExistingSubscriptions() {
        Task.init {
            if await PremiumManager.shared.isPremiumExist() {
                subButton.isEnabled = false
                subButton.setTitle("Subscribed", for: .disabled)
                subButton.titleLabel?.textColor = .gray
                subButton.backgroundColor = .lightGray
            }
            
            if await PremiumManager.shared.isPremiumExist(for: [.monthly]) {
                let disabledTitle = "     Monthly - ALREADY HAVE"
                sub2Button.setTitle(disabledTitle, for: .disabled)
                subSelect = .yearly
                DispatchQueue.main.async {
                    self.sub2Button.isEnabled = false
                }
                
                
            } else if await PremiumManager.shared.isPremiumExist(for: [.yearly]) {
                let disabledTitle = "     Yearly - ALREADY HAVE"
                subSelect = .monthly
                sub1Button.setTitle(disabledTitle, for: .disabled)
                DispatchQueue.main.async {
                    self.sub1Button.isEnabled = false
                }
            }
        }
        
    }
}
