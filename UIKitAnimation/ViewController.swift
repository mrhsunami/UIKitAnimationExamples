//
//  ViewController.swift
//  UIKitAnimation
//
//  Created by Nathan Hsu on 2019-07-09.
//  Copyright © 2019 Nathan Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let box = UIView()
    let circle = UIView()
    var circleIsAtBottom: Bool = false
    
    var downAnimator = UIViewPropertyAnimator()
    var upAnimator = UIViewPropertyAnimator()
    var rotate = UIViewPropertyAnimator()
    var circleAnimator = UIViewPropertyAnimator()
    
    func setupAnimator() {
        checkCircleLocation()
        if circleIsAtBottom {
            upAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                self.circle.frame = self.circle.frame.offsetBy(dx: 0, dy: -400)
                self.circle.backgroundColor = .blue
            }
            upAnimator.addCompletion { (position) in
                self.checkCircleLocation()
            }
            circleAnimator = upAnimator
        } else {
            downAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                self.circle.frame = self.circle.frame.offsetBy(dx: 0, dy: 400)
                self.circle.backgroundColor = .red
            }
            downAnimator.addCompletion { (position) in
                self.checkCircleLocation()
            }
            circleAnimator = downAnimator
        }
    }
    func checkCircleLocation() {
        if self.circle.center.y > view.bounds.height/2 {
            circleIsAtBottom = true
        } else {
            circleIsAtBottom = false
        }
    }
    
    @objc func handlePan(from recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: circle)
        
        switch recognizer.state {
        case .began:
            setupAnimator()
            circleAnimator.startAnimation()
            circleAnimator.pauseAnimation()
        case .changed:
            if circleIsAtBottom {
                circleAnimator.fractionComplete = (translation.y / -400)
            } else {
                circleAnimator.fractionComplete = (translation.y / 400)
            }
        case .ended:
            circleAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
        default:
            return
        }
        
    }
    @objc func handleTap(from recognizer: UITapGestureRecognizer) {
        
        rotate = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                for i in 1...20 {
                    let startTime = Double(i) * 0.1
                    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: 0.1, animations: {
                        self.circle.transform = self.circle.transform.rotated(by: .pi/4)
                    })
                }
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
                    self.circle.layer.cornerRadius = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                    self.circle.layer.cornerRadius = self.circle.frame.width/2
                })
            }, completion: { (true) in
                print("rotated")
            })
            
        })
        
        rotate.startAnimation()
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    override func viewDidLoad() {
        
        //Setup Circle
        circle.frame = CGRect(x: 375/2-50, y: 100, width: 100, height: 100)
        circle.layer.cornerRadius = circle.frame.width/2
        circle.backgroundColor = .blue
        view.addSubview(circle)
        
        //Setup Animator
        setupAnimator()
        
        //Setup Gestures
        let dragGestureRecognzier = UIPanGestureRecognizer()
        dragGestureRecognzier.addTarget(self, action: #selector(handlePan(from:)))
        circle.addGestureRecognizer(dragGestureRecognzier)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(from:)))
        circle.addGestureRecognizer(tapGestureRecognizer)
        
        //Opening Animations
        UIView.animate(withDuration: 0.5, animations: {
            self.circle.backgroundColor = .red
            self.circle.frame = CGRect(x: 375/2-100, y: 300, width: 200, height: 200)
            self.circle.layer.cornerRadius = self.circle.frame.width/2
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.circle.backgroundColor = .blue
                self.circle.frame = CGRect(x: 375/2-50, y: 100, width: 100, height: 100)
                self.circle.layer.cornerRadius = self.circle.frame.width/2
            })
        }
    }
    
}

