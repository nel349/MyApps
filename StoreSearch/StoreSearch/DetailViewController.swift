//
//  ViewController.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/26/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var downloadTask: URLSessionDownloadTask?
    
    var searchResult: SearchResult!
    
    enum AnimationStyle {
        case slide
        case fade }
    var dismissAnimationStyle = AnimationStyle.fade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255,
                                 alpha: 1)
        popupView.layer.cornerRadius = 10
        
        if searchResult != nil {
            updateUI()
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = true
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        view.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Localized Uknown reference")
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        
        kindLabel.text = searchResult.kindForDisplay()
        genreLabel.text = searchResult.genre
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Localized Free reference")
        } else if let text = formatter.string(from: searchResult.price as NSNumber){
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        
        if let largeURL = URL(string: searchResult.artworkLargeURL) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        dismissAnimationStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
}


extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissAnimationStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
