//
//  ReviewsPage.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 23.07.2022.
//

import UIKit


final class ReviewsPage: UIView {
    
    private let reviewHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let reviewerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 12)
        button.tintColor =  #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)  //#A2ABF1
//        button.titleLabel?.textColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)  //#A2ABF1
        button.titleLabel?.text = "Reviewer Reviewer Reviewer"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-SemiBold", size: 36)
        label.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
        label.text = "Reviews"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reviewViews: [ReviewView] = {
        let reviews = Review.getAllReviews()
        var reviewViews = Array<ReviewView>()
        reviews.forEach { review in
            reviewViews.append(ReviewView(review: review))
        }
        return reviewViews
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
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 0.9333333333, alpha: 1) //#5A6BEE
        pageControl.pageIndicatorTintColor =  #colorLiteral(red: 0.1215686275, green: 0.1529411765, blue: 0.4039215686, alpha: 1) //#1F2767
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlDidChange(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pageControlDidChange(sender: UIPageControl) {
        let screenPoint = UIScreen.main.bounds.width
        let currentPageFloat = CGFloat(sender.currentPage)
        let pointY = scrollView.bounds.minY
        scrollView.setContentOffset(CGPoint(x: (screenPoint * currentPageFloat), y: pointY), animated: true)
    }
    
    
    private func setPrimarySettings() {
        addSubview(label)
        let spacerView =  UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        pageControl.numberOfPages = reviewViews.count
        
        reviewHeaderStackView.addArrangedSubview(reviewerButton)
        reviewHeaderStackView.addArrangedSubview(spacerView)
        reviewHeaderStackView.addArrangedSubview(pageControl)
        addSubview(reviewHeaderStackView)
        addSubview(scrollView)
        setupConstraints()
        setPages()
    }
    
    private func setupConstraints() {
        let reviewerPadding = 28.0
        let padding = 16.0
        let topPadding = 119.0
        
        
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: topPadding)
            .isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        
        reviewHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: reviewerPadding)
            .isActive = true
        reviewHeaderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding)
            .isActive = true
        reviewHeaderStackView.heightAnchor.constraint(equalToConstant: padding)
            .isActive = true
        reviewHeaderStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        
        scrollView.topAnchor.constraint(equalTo: reviewHeaderStackView.bottomAnchor)
            .isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
            .isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
            .isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
        
    }
    
    private func setPages() {
        scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(reviewViews.count)
        
        for (index, page) in reviewViews.enumerated() {
            page.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(page)
            page.widthAnchor.constraint(equalTo: widthAnchor)
                .isActive = true
            
            if index == .zero {
                let reviews = Review.getAllReviews()
                reviewerButton.setTitle(reviews[index].name, for: .normal)
                page.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
                .isActive = true } else {
                    page.leadingAnchor.constraint(equalTo: reviewViews[index-1].trailingAnchor)
                        .isActive = true
                }
        }
        
    }
    
}

extension ReviewsPage: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let width = UIScreen.main.bounds.width
            let reviews = Review.getAllReviews()
            pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(width)))
            let reviewerName = reviews[pageControl.currentPage].name
            reviewerButton.setTitle(reviewerName, for: .normal)
        }
    }
}
