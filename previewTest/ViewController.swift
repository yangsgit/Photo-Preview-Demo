//
//  ViewController.swift
//  previewTest
//
//  Created by Yang Li on 1/31/19.
//  Copyright © 2019 Yang Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    var images:[String]!{
        didSet{
            // create each imageView for each image
            var imageViews = [UIImageView]()
            for i in 0..<images.count{
                let iv = UIImageView(image: UIImage(named: images[i]))
                iv.contentMode = .scaleAspectFit
                imageViews.append(iv)
            }
            subImageViews = imageViews
        }
    }
    
    var subImageViews:[UIImageView]!{
        didSet{
            // create each scrollview for each imageView
            var scrollViews = [UIScrollView]()
            for i in 0..<images.count{
                
                // configure subscrollview
                let sv = UIScrollView()
                sv.showsVerticalScrollIndicator = false
                sv.showsHorizontalScrollIndicator = false
                sv.backgroundColor = UIColor.blue
                sv.delegate = self
                sv.zoomScale = 1
                sv.maximumZoomScale = 3.0
                sv.minimumZoomScale = 1.0
                
                // add subImageView to scrollView
                sv.addSubview(subImageViews[i])
                
                // add to main ScrollView
                self.mainScrollView.addSubview(sv)
                scrollViews.append(sv)
            }
            subScrolls = scrollViews
        }
    }
    
    
    var subScrolls:[UIScrollView]!{
        didSet{
            resizeSubScrollViews()
        }
    }
    
    var currentPage:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        images = ["image1.jpg","image2.jpg","image3.jpg"]
    }
    
    override func viewDidLayoutSubviews() {
        resizeSubScrollViews()
    }
    
    // reset the all views' frame and origin
    func resizeSubScrollViews(){
        mainScrollView.contentSize.width = self.view.frame.width * CGFloat(images.count)
        for i in 0..<(subScrolls?.count ?? 0){
            
            // reset the origin
            let x = self.view.frame.width * CGFloat(i)
            
            // reset the subScrolls frame
            self.subScrolls[i].frame = CGRect(origin: CGPoint(x: x, y: 0), size: self.view!.frame.size)
            

            // if we don't reset scale and rorate screen after scalling photo， at this time,
            // content size and scroll view frame are all set to scrren's size
            // However, the scale won't change, which will be 3, because the max scale is 3
            // so at this time, we can only zoom in instead of zoom out. That's why reset
            self.subScrolls[i].setZoomScale(1.0, animated: true)

            // reset content size & zoom scale
            //Note: content size & frame size are totally independent，if we rotate,frame & content all will keep their origin size
            //      even one changed, another won't follow it to change
            self.subScrolls[i].contentSize = self.view!.frame.size
            
            // reset the subImageViews' frame,
            self.subImageViews[i].frame = CGRect(origin: CGPoint(x:0, y:0), size: self.view!.frame.size)
            self.subScrolls[i].contentSize = self.subImageViews[i].frame.size

        }
        //stay to current image after rotate
        self.mainScrollView.contentOffset.x = currentPage * self.view.frame.width
    }
    
    // calculate the current page number after scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = self.mainScrollView.contentOffset.x / self.view.frame.size.width
    }
    
    
    // this delegate allow to zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for subview in scrollView.subviews{
            if subview is UIImageView{
                return subview
            }
        }
        return nil
    }
}

