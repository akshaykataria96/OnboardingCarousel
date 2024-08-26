//
//  ViewController.swift
//  OnboardingCarousel
//
//  Created by Akshay Kataria on 23/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var carouselView: ImageCarouselView!
    private let images: [String] = ["canada", "germany", "india", "united-kingdom", "united-states"]
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView = ImageCarouselView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250),
                                         imageNames: images)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView.scrollToCenter()
    }
    
    // MARK: -
    
    private func setupConstraints() {
        view.addSubview(carouselView)
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 250),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

