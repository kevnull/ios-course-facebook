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

class PhotoViewController: UIViewController {

    var photo : UIImage!
    var originalCenter : CGPoint!
    
    @IBOutlet weak var doneButtonView: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoActionsView: UIImageView!

    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.hidden = true
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
    
    @IBAction func onPanPhoto(gestureRecognizer : UIPanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var x : CGFloat = photoView.frame.origin.x
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            originalCenter = photoView.center

        // change alpha to be clearer as dragging farther
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
            photoView.center.y = originalCenter.y + translation.y
            view.backgroundColor = view.backgroundColor?.colorWithAlphaComponent( CGFloat (transformValue( Float( abs(translation.y) ), 0, 568, 0.9, 0.4) ) )
            self.doneButtonView.alpha = 0
            self.photoActionsView.alpha = 0

        // determine whether to return photo to place
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            if (abs(translation.y) < 100) {
                UIView.animateWithDuration(0.4,
                                    delay: 0,
                   usingSpringWithDamping: 1,
                    initialSpringVelocity: 1,
                                  options: UIViewAnimationOptions.CurveEaseInOut,
                               animations: { () -> Void in
                        self.photoView.center.y = self.originalCenter.y
                        self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(1)
                        self.doneButtonView.alpha = 1
                        self.photoActionsView.alpha = 1
                    }, completion: nil)
                
            } else {
                self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(0)
                self.view.frame = self.photoView.frame
                self.photoView.center = self.view.center
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
