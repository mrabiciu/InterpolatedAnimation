//
//  ButtonContainerView.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit


class ButtonContainerView: UIView {
  let button: UIButton = {
    let button = UIButton()
    button.backgroundColor = .black
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.setTitle("REQUEST NOOBERX", for: .normal)
    return button
  }()
  
  let circle: UIView = {
    let circle = UIView()
    circle.backgroundColor = .gray
    circle.layer.cornerRadius = 15
    return circle
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.numberOfLines = 2
    label.text = "Personal\nVisa 1234"
    label.textColor = .gray
    return label
  }()
  
  let divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.85, alpha: 1)
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [button, circle, label, divider].forEach { addSubview($0) }
    installConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func installConstraints() {
    let views = ["divider": divider, "label": label, "circle": circle, "button": button]
    views.forEach { _, view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    let constraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[divider(0.5)]-15-[circle(30)]-15-[button(50)]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[divider]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[circle(30)]-10-[label]|", options: [], metrics: nil, views: views),
      [label.centerYAnchor.constraint(equalTo: circle.centerYAnchor)]
      
      ].flatMap({ $0 })
    NSLayoutConstraint.activate(constraints)
  }
  
}
