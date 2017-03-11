//
//  TwoLabelAndLineView.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

class TwoLabelAndLineView: UIView {
  let leftLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let rightLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let line: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.85, alpha: 1)
    return view
  }()
  
  init(leftTitle: String, rightTitle: String) {
    super.init(frame: .zero)
    leftLabel.text = leftTitle
    rightLabel.text = rightTitle
    [rightLabel, leftLabel, line].forEach { addSubview($0) }
    installConstraints()
  }
  
  private func installConstraints() {
    let views = ["rightLabel": rightLabel, "leftLabel": leftLabel, "line": line]
    views.forEach { _, view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    let constraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[rightLabel]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftLabel]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:[line(0.5)]-2-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftLabel]-5-[line]-5-[rightLabel]|", options: [], metrics: nil, views: views),
      ].flatMap({ $0 })
    NSLayoutConstraint.activate(constraints)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
