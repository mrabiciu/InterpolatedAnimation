//
//  BoxController.swift
//  Animation
//
//  Created by Max on 3/8/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit
import InterpolatedAnimation

class BoxController: UIViewController {
  var animation: InterpolatedAnimation!
  let box = UIView()
  let slider = UISlider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(box)
    view.addSubview(slider)
    slider.frame = CGRect(x: 30, y: view.frame.size.height - 40, width: view.frame.size.width - 60, height: 20)
    slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    
    // Initial layout and color
    box.backgroundColor = .red
    box.frame = CGRect(x: view.frame.size.width / 2 - 20, y: view.frame.size.height / 2 + 100, width: 40, height: 40)
    
    // Final layout and color
    animation = view.interpolatedAnimation {
      self.box.frame = CGRect(x: self.view.frame.size.width / 2 - 20, y: self.view.frame.size.height / 2 - 100, width: 40, height: 40)
      self.box.backgroundColor = .green
      self.box.transform = CGAffineTransform(scaleX: 5, y: 2)
      self.box.alpha = 0.1
    }
  }
  
  @objc func valueChanged() {
    animation.percent = Double(slider.value)
  }
}
