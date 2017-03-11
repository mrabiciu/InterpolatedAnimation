//
//  StackController.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit
import InterpolatedAnimation

class StackingView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(white: 0.85, alpha: 1)
    layer.cornerRadius = 4.0
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.black.cgColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class StackController: UIViewController {
  var views: [StackingView] = []
  var animation: InterpolatedAnimation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesture:))))
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:))))
    for _ in 0..<5 {
      let stackingView = StackingView()
      views.append(stackingView)
      view.insertSubview(stackingView, at: 0)
    }
    
    // Create an initial set of constraints and perform layout
    var constraints: [NSLayoutConstraint] = []
    for (i, view) in self.views.enumerated() {
      view.transform = CGAffineTransform(scaleX: CGFloat(1.0 - 0.02 * Double(i)), y: CGFloat(1.0 - 0.02 * Double(i)))
      view.translatesAutoresizingMaskIntoConstraints = false
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[view]-20-|", options: [], metrics: nil, views: ["view": view])
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[view(50)]-padding-|", options: [], metrics: ["padding": 15 - (i * 2)], views: ["view": view])
    }
    NSLayoutConstraint.activate(constraints)
    self.view.layoutIfNeeded()

    // We activate a totally different set of constraints and perform layout inside the animation block
    views = views.reversed()
    animation = view.interpolatedAnimation {
      NSLayoutConstraint.deactivate(constraints)
      var expandedConstraints: [NSLayoutConstraint] = []
      self.view.backgroundColor = UIColor(white: 0.4, alpha: 1)
      for (i, view) in self.views.enumerated() {
        view.transform = .identity
        view.backgroundColor = .white
        expandedConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[view]-5-|", options: [], metrics: nil, views: ["view": view])
        guard i > 0 else {
          expandedConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[view(100)]-5-|", options: [], metrics: nil, views: ["view": view])
          continue
        }
        expandedConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[view(100)]-5-[last]", options: [], metrics: nil, views: ["view": view, "last": self.views[i - 1]])
      }
      NSLayoutConstraint.activate(expandedConstraints)
      self.view.layoutIfNeeded()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animation.percent = 0
  }
  
  func didPan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    
    animation.percent -= Double(translation.y) / Double(330)
    
    // Animate to final state by wrapping percent setter in an animation block
    if gesture.state == .ended {
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowAnimatedContent], animations: {
        if gesture.velocity(in: self.view).y < 0 {
          self.animation.percent = 1
        } else {
          self.animation.percent = 0
        }
      }, completion: nil)
    }
    gesture.setTranslation(.zero, in: view)
  }
  
  @objc func didTap(gesture: UIPanGestureRecognizer) {
    // Animate to final state by wrapping percent setter in an animation block
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowAnimatedContent, .allowUserInteraction], animations: {
      if self.animation.percent > 0 {
        self.animation.percent = 0
      } else {
        self.animation.percent = 1
      }
    }, completion: nil)
  }
  
}

