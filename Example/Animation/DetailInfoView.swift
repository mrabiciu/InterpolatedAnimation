//
//  DetailInfoView.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

class DetailInfoView: UIView {
  let line1 = TwoLabelAndLineView(leftTitle: "Fare", rightTitle: "$4.20")
  let line2 = TwoLabelAndLineView(leftTitle: "Capacity", rightTitle: "1-4")
  let line3 = TwoLabelAndLineView(leftTitle: "Estimated Arrival", rightTitle: "4:20pm")
  let divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.85, alpha: 1)
    return view
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.text = "DONE"
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [line1, line2, line3, divider, label].forEach { addSubview($0) }
    installConstraints()
  }
  
  private func installConstraints() {
    let views = ["line1": line1, "line2": line2, "line3": line3, "divider": divider, "label": label]
    views.forEach { _, view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    let constraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[line1]-5-[line2]-5-[line3]-(>=10)-[divider(0.5)]-15-[label]-15-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[line1]-40-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[line2]-40-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[line3]-40-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[divider]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: views),
      
      ].flatMap({ $0 })
    NSLayoutConstraint.activate(constraints)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
