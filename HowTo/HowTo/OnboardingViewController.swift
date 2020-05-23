//
//  OnboardingViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Outlets & Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    var images: [String] = ["0", "1", "2"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // MARK: - Lifecycle & init's
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
        
    // MARK: - Actions & Methods
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    @IBAction func continueAsGuestButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func updateViews() {
        navigationController?.isNavigationBarHidden = true
        // how many pages page control should have
        pageControl.numberOfPages = images.count
        // this sets the scroll view size to (frame x however many images there are)
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            // intialize image view
            let imageView = UIImageView(frame: frame)
            // images are named to match the index number
            imageView.image = UIImage(named: images[index])
            // add it to scroll view, set content to aspect fill and clip it to bounds
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            self.scrollView.addSubview(imageView)
        }
        // set the scroll view to 3x as wide because there are 3 images, height stays so you can't scroll vertically
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: 0)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // change image and set page to current page
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

}
