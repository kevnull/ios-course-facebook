//
//  FeedViewController.swift
//  ios-course-facebook
//
//  Created by Kevin Cheng on 9/18/14.
//  Copyright (c) 2014 Kevin Cheng. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var isPresenting : Bool = true
    var imageView : UIImageView!
    var expandView : UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!

    @IBOutlet weak var wedding1View: UIImageView!
    @IBOutlet weak var wedding2View: UIImageView!
    @IBOutlet weak var wedding3View: UIImageView!
    @IBOutlet weak var wedding4View: UIImageView!
    @IBOutlet weak var wedding5View: UIImageView!

    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }

    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        println("animating transition: \(isPresenting)")
        
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        if (isPresenting) {
            containerView.addSubview(toViewController.view)

            expandView = UIImageView(frame: imageView.frame)
            expandView.image = imageView.image
            println(expandView.frame)
            containerView.addSubview(expandView)
            expandView.contentMode = UIViewContentMode.ScaleAspectFill
            expandView.clipsToBounds = true

            toViewController.view.alpha = 0
            expandView.alpha = 1
            imageView.hidden = true

            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.expandView.frame = CGRect(x: 0, y: 64, width: 320, height: 440)
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    self.expandView.alpha = 0
                    transitionContext.completeTransition(true)
            }

            
        } else {
            println(transitionContext.initialFrameForViewController(fromViewController))
            var fromScrollView = fromViewController as PhotoViewController
            
            println(fromScrollView.photoView.frame.origin)
            println(fromScrollView.scrollView.contentOffset)
            self.expandView.frame = CGRectMake(fromScrollView.photoView.frame.origin.x, fromScrollView.photoView.frame.origin.y - fromScrollView.scrollView.contentOffset.y, fromScrollView.photoView.frame.size.width, fromScrollView.photoView.frame.size.height)
            self.expandView.alpha = 1
            fromScrollView.photoView.hidden = true

            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.expandView.frame = self.imageView.frame
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    self.imageView.hidden = false
                    self.expandView.alpha = 0
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize.width = feedView.frame.size.width
        scrollView.contentSize.height = navView.frame.size.height + feedView.frame.size.height
    }

    
    @IBAction func onTapPhoto(gestureRecognizer : UITapGestureRecognizer) {

        if (gestureRecognizer.view == self.wedding1View) {
            self.imageView = wedding1View

        } else if (gestureRecognizer.view == self.wedding2View) {
            self.imageView = wedding2View

        } else if (gestureRecognizer.view == self.wedding3View) {
            self.imageView = wedding3View

        } else if (gestureRecognizer.view == self.wedding4View) {
            self.imageView = wedding4View

        } else if (gestureRecognizer.view == self.wedding5View) {
            self.imageView = wedding5View
        }

        performSegueWithIdentifier("expandPhotoSegue", sender: self)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        var destinationViewController = segue.destinationViewController as PhotoViewController

        if (imageView.image != nil) {
            destinationViewController.photo = self.imageView.image
        }

        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}