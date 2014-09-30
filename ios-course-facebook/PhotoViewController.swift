//
//  PhotoViewController.swift
//  ios-course-facebook
//
//  Created by Kevin Cheng on 9/18/14.
//  Copyright (c) 2014 Kevin Cheng. All rights reserved.
//

import UIKit

// given scale of x to y, find where value fits on scale of a to b
func transformValue (value : Float, x : Float, y : Float, a : Float, b: Float) -> Float {
    return (value/(y-x)*(b-a))+a
}

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    var photo : UIImage!
    var photoNum : Int!
    var originalPoint : CGPoint!
    
    @IBOutlet weak var doneButtonView: UIButton!
    @IBOutlet weak var photoView1: UIImageView!
    @IBOutlet weak var photoView2: UIImageView!
    @IBOutlet weak var photoView3: UIImageView!
    @IBOutlet weak var photoView4: UIImageView!
    @IBOutlet weak var photoView5: UIImageView!
    @IBOutlet weak var photoActionsView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var photoViews : [UIImageView]! = []
    var photoView : UIImageView!
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoViews.append(photoView1)
        photoViews.append(photoView2)
        photoViews.append(photoView3)
        photoViews.append(photoView4)
        photoViews.append(photoView5)
        photoView = photoViews[photoNum]
        originalPoint = self.scrollView.contentOffset
        self.photoView.hidden = true
        self.scrollView.delegate = self
        self.scrollView.frame = CGRectMake(0, 0, 320, 568)
        self.scrollView.contentSize = CGSizeMake(1600, 1000)
        self.scrollView.contentOffset.x = CGFloat (photoNum) * 320
        println("1 originalPoint = \(originalPoint)")
        
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        centerScrollViewContents()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.photoView.hidden = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset = scrollView.contentOffset
        
        if (abs(offset.y) < 100) {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.scrollView.contentOffset = self.originalPoint
                self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(1)
                self.doneButtonView.alpha = 1
                self.photoActionsView.alpha = 1
            })
        } else {
                self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(0)
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // any offset changes
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        var alpha = CGFloat (transformValue( Float( abs(offset.y) ), 0, 300, 0.9, 0.4) )
        println("scroll offset = \(offset) and originalPoint = \(originalPoint)")
        if (abs(offset.x - originalPoint.x) > 0) {
            scrollView.pagingEnabled = true
            originalPoint.x = scrollView.contentOffset.x
            photoNum = Int(round(scrollView.contentOffset.x / 320))
            photoView = photoViews[photoNum]
        } else {
            scrollView.pagingEnabled = false
            view.backgroundColor = view.backgroundColor?.colorWithAlphaComponent( alpha )
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.doneButtonView.alpha = 0
                self.photoActionsView.alpha = 0
            })
        }
    }

}
