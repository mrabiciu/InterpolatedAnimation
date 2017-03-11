//
//  NooberViewController.swift
//  Animation
//
//  Created by Max on 12/14/16.
//  Copyright © 2016 Maxim Rabiciuc. All rights reserved.
//

import UIKit
import InterpolatedAnimation

enum State {
  case compact, expanded
}

class NooberViewController: UIViewController {
  let drawer: DrawerView = {
    let view = DrawerView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var layoutAnimation: InterpolatedAnimation!
  var alphaAnimation: InterpolatedAnimation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(drawer)
    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesture:))))
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:))))
    view.backgroundColor = UIColor(white: 0.8, alpha: 1)
    view.clipsToBounds = true
    
    let views = ["drawer": drawer]
    NSLayoutConstraint.activate([
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[drawer]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:[drawer]|", options: [], metrics: nil, views: views),
    ].flatMap({ $0 }))
    setUpAnimations()
  }
  
  func setUpAnimations() {
    // Move to initial state
    self.drawer.state = .compact
    self.drawer.buttonContainer.alpha = 1
    self.drawer.detailInfoView.alpha = 0
    drawer.detailView2.smallLabelView.alpha = 1
    [self.drawer.detailView1, self.drawer.detailView2].forEach { view in
      view.largeLabel.alpha = 0
      view.timeLabel.alpha = 1
      view.priceLabel.alpha = 1
    }
    self.view.setNeedsLayout()
    self.view.layoutIfNeeded()
    
    // We use two animations side by side, one to control layout and another to control alpha
    layoutAnimation = view.interpolatedAnimation {
      self.drawer.state = .expanded
      self.view.backgroundColor = UIColor(white: 0.3, alpha: 1)
      self.view.layoutIfNeeded()
    }
    
    // Control alpha with a separate animation because it uses different timing
    alphaAnimation = view.interpolatedAnimation(
      captureMode: .exact,
      KeyFrame(percent: 0.4) {
        self.drawer.buttonContainer.alpha = 0
      }, KeyFrame(percent: 0.8) {
        self.drawer.detailInfoView.alpha = 1
        [self.drawer.detailView1, self.drawer.detailView2].forEach { view in
          view.detailLabel.alpha = 1
          view.largeLabel.alpha = 1
          view.timeLabel.alpha = 0
          view.priceLabel.alpha = 0
          view.smallLabelView.alpha = 0
        }
    })
  }

  @objc func didPan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
  
    // Use translation to determine percent
    // Update both animations at once
    layoutAnimation.percent -= Double(translation.y) / Double(190)
    alphaAnimation.percent = layoutAnimation.percent

    // Animate to final state by wrapping the percent setter in an animation block
    if gesture.state == .ended {
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowAnimatedContent], animations: {
        if gesture.velocity(in: self.view).y < 0 {
          self.layoutAnimation.percent = 1
          self.alphaAnimation.percent = 1
        } else {
          self.layoutAnimation.percent = 0
          self.alphaAnimation.percent = 0
        }
        
        self.view.layoutIfNeeded()
        self.drawer.layoutIfNeeded()
      }, completion: nil)
    }
    gesture.setTranslation(.zero, in: view)
  }
  
  @objc func didTap(gesture: UIPanGestureRecognizer) {
    // To animate to a final state just wrap the percent setter in an animation block
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowAnimatedContent, .allowUserInteraction], animations: {
      if self.layoutAnimation.percent > 0 {
        self.layoutAnimation.percent = 0
        self.alphaAnimation.percent = 0
      } else {
        self.layoutAnimation.percent = 1
        self.alphaAnimation.percent = 1
      }
    }, completion: nil)

  }
  
  
}

