//
//  ImageCarouselView.swift
//  OnboardingCarousel
//
//  Created by Akshay Kataria on 26/08/24.
//

import Foundation
import UIKit

final class ImageCarouselView: UIView {
    
    // MARK: - Private Properties
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var imageViews: [UIImageView] = []
    private let pageControl = UIPageControl()
    private let imageNames: [String]
    
    private var numberOfItems: Int {
        imageNames.count
    }
    
    // MARK: -
    
    init(frame: CGRect, imageNames: [String]) {
        self.imageNames = imageNames
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setupView() {
        setupScrollView()
        setupStackView()
        setupPageControl()
        setupConstraints()
        scrollView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        addSubview(scrollView)
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        for imageName in imageNames {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            stackView.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = numberOfItems
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
    }
    
    private func setupConstraints() {
        // Scroll View Constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Image View Constraints
        for view in imageViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
        }
        
        // Stack View Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Page Control Constraints
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let pageIndex = sender.currentPage
        let xOffset = CGFloat(pageIndex) * (scrollView.bounds.width)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    // MARK: - Public Methods
    
    func scrollToCenter() {
        let centerIndex = numberOfItems / 2
        let offsetX = CGFloat(centerIndex) * (scrollView.bounds.width)
        let adjustedOffsetX = max(0, min(offsetX, scrollView.contentSize.width - scrollView.bounds.width))
        scrollView.setContentOffset(CGPoint(x: adjustedOffsetX, y: 0), animated: false)
    }
}

// MARK: -

extension ImageCarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        for imageView in imageViews {
            let imageViewCenterX = imageView.center.x
            let distanceFromCenter = abs(imageViewCenterX - centerX)
            let scale = max(0.8, 1 - distanceFromCenter / (scrollView.bounds.width * 1.4))
            imageView.transform = CGAffineTransform(scaleX: 1, y: scale)
        }
        // Update page control
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
