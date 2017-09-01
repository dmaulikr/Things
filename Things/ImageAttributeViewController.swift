//
//  ImageAttributeViewController.swift
//  Things
//
//  Created by Brianna Lee on 5/9/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

class ImageAttributeViewController: UIViewController, UIScrollViewDelegate {
    
    ///This needs to be added to the Storyboard so that constraints are present and the app can be used in landscape mode.
    
    var image: UIImage!
    
    var scrollView: UIScrollView!
    var attributeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        attributeImageView = UIImageView(frame: scrollView.bounds)
        attributeImageView.contentMode = .scaleAspectFit
        attributeImageView.image = image
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(attributeImageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return attributeImageView
    }
}
