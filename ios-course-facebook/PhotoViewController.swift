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
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        let scaleWidth = scrollView.frame.size.width / photoView.image!.size.width
        let scaleHeight = scrollView.frame.size.height / photoView.image!.size.height
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
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = photoView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        photoView.frame = contentsFrame
    }

    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        println("yo")
        let pointInView = recognizer.locationInView(photoView)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
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
