//
//  OnboardingViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 22.07.2022.
//

import UIKit


final class OnboardingViewController: UIViewController {
    
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    let views: [UIView] = [
        FirstPage(),
        SecondPage(),
        ThirdPage(),
        ReviewsPage()
    ]
    
    let colors: [UIColor] =  [
        .clear,
        .yellow,
        .red,
        .green
    ]
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 0.9333333333, alpha: 1) //#5A6BEE
        pageControl.pageIndicatorTintColor =  #colorLiteral(red: 0.1215686275, green: 0.1529411765, blue: 0.4039215686, alpha: 1) //#1F2767
        let indicatorImage = UIImage(named: "Page_Indicator")
        pageControl.preferredIndicatorImage = indicatorImage
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlDidChange(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 0.9333333333, alpha: 1) //#5A6BEE
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.layer.cornerRadius = 17
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  .clear
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.layer.cornerRadius = 17
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setGUISettings()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    @objc private func startButtonTapped(sender: UIButton) {
        sender.isEnabled = false
        let onboardingVC = OnboardingViewController()
        show(onboardingVC, sender: nil)
    }
    
    @objc private func pageControlDidChange(sender: UIPageControl) {
        let screenPoint = UIScreen.main.bounds.width
        let currentPageFloat = CGFloat(sender.currentPage)
        
        scrollView.setContentOffset(CGPoint(x: (screenPoint * currentPageFloat), y: 0), animated: true)
    }
        
        private func setGUISettings() {
            view.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.06274509804, blue: 0.2, alpha: 1)  //#0B1033
            view.addSubview(scrollView)
            view.addSubview(buttonsStackView)
            view.addSubview(pageControl)
            buttonsStackView.addArrangedSubview(skipButton)
            buttonsStackView.addArrangedSubview(nextButton)
            setScrollViewSettings()
            setPageControlSettings()
            setStackViewSettings()
            setPages()
        }
        
    private func setScrollViewSettings() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor)
            .isActive = true
        scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
            .isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            .isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
    }
    
    private func setPageControlSettings() {
        let height = 52.0
        let padding = 10.0
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor)
            .isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        pageControl.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -padding)
            .isActive = true
    }
        
        private func setStackViewSettings() {
            let bottomPadding = 45.0
            let height = 56.0
            let skipButtonWidth = 101.0
            let padding = 16.0
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomPadding)
                .isActive = true
            buttonsStackView.heightAnchor.constraint(equalToConstant: height)
                .isActive = true
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding)
                .isActive = true
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
                .isActive = true
            
            
            skipButton.widthAnchor.constraint(equalToConstant: skipButtonWidth)
                .isActive = true
        }
    
    private func  setPages() {
        scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(views.count)
        
        for (index, page) in views.enumerated() {
            page.translatesAutoresizingMaskIntoConstraints = false
            page.backgroundColor = colors[index]
            scrollView.addSubview(page)
            page.widthAnchor.constraint(equalTo: view.widthAnchor)
                .isActive = true
            page.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
                .isActive = true
            
            
            if index == .zero {
                page.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
                    .isActive = true
            } else {
                page.leadingAnchor.constraint(equalTo: views[index-1].trailingAnchor)
                    .isActive = true
            }
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(width)))
    }
}

    

