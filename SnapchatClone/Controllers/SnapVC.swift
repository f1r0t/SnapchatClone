//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Fırat AKBULUT on 25.10.2023.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    
    var selectedSnap: Snap?
    var inputArray = [KingfisherSource]()

    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let snap = selectedSnap {
            timeLabel.text = "Time Left: \(snap.timeDifference!)"

            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            let pageIndıcator = UIPageControl()
            pageIndıcator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndıcator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndıcator
            
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
        
    }
    


}
