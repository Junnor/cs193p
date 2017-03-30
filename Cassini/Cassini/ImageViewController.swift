//
//  ViewController.swift
//  Cassini
//
//  Created by Ju on 2017/3/30.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fecthImage()
            }
        }
    }
    
    private func fecthImage() {
        if let url = imageURL {
            
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                print("1 url = \(url)")
                let urlContent = try? Data(contentsOf: url)
                print("2 .. \(urlContent)\n \(self?.imageURL)")
                if let imageData = urlContent, url == self?.imageURL {
                    print("3")
                    DispatchQueue.main.async {
                        print("4")
                        self?.image = UIImage(data: imageData)
                    }
                }

            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil {
            fecthImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 0.05
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
