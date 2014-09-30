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
    var originalPoint : CGPoint!
    
    @IBOutlet weak var doneButtonView: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoActionsView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.hidden = true
        self.scrollView.delegate = self
        self.scrollView.frame = CGRectMake(0, 0, 320, 568)
        self.scrollView.contentSize = CGSizeMake(320, 1000)
        originalPoint = self.scrollView.contentOffset
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.photoView.image = self.photo
            self.photoView.hidden = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset = Float(scrollView.contentOffset.y)

        if (abs(offset) < 100) {
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
        var offset = Float(scrollView.contentOffset.y)
        var alpha = CGFloat (transformValue( Float( abs(offset) ), 0, 300, 0.9, 0.4) )
        view.backgroundColor = view.backgroundColor?.colorWithAlphaComponent( alpha )
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.doneButtonView.alpha = 0
            self.photoActionsView.alpha = 0
        })
    }

}
