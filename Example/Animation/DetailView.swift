//
//  DetailView.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

class DetailView: UIView {
  var state: State = .compact {
    didSet {
      move(to: state)
    }
  }
  
  let carView: UIView = {
    let view = UIImageView(image: UIImage(named: "gray-circle"))
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  let smallLabelView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    
    let label = UILabel()
    view.backgroundColor = .black
    label.text = "nooberX"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 12)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.lineBreakMode = .byClipping
    
    view.addSubview(label)
    let views = ["label": label]
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-7-[label]-7-|", options: [], metrics: nil, views: views))
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[label]-3-|", options: [], metrics: nil, views: views))
    
    return view
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.text = "Such cheap, much deal"
    return label
  }()
  
  let largeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 25)
    label.textAlignment = .center
    label.text = "nooberX"
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.text = "$4.20"
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.text = "4:20pm"
    return label
  }()
  
  var compactConstraints: [NSLayoutConstraint] = []
  var expandedConstraints: [NSLayoutConstraint] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [carView, smallLabelView, priceLabel, timeLabel, detailLabel, largeLabel].forEach { view in
      addSubview(view)
    }
    installConstraints()
    move(to: state)
    detailLabel.alpha = 0
    largeLabel.alpha = 0
    timeLabel.alpha = 1
    priceLabel.alpha = 1
    smallLabelView.alpha = 1

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func move(to state: State) {
    switch state {
    case .expanded:
      NSLayoutConstraint.deactivate(compactConstraints)
      NSLayoutConstraint.activate(expandedConstraints)
    case .compact:
      NSLayoutConstraint.deactivate(expandedConstraints)
      NSLayoutConstraint.activate(compactConstraints)
    }
    setNeedsLayout()
  }
  
  private func installConstraints() {
    let views = ["carView": carView, "smallLabelView": smallLabelView, "priceLabel": priceLabel, "timeLabel": timeLabel, "detailLabel": detailLabel, "largeLabel": largeLabel]
    views.forEach { _, view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let permanentConstraints = [
//      NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[carView]-30-|", options: [], metrics: nil, views: views),
      [
        smallLabelView.bottomAnchor.constraint(equalTo: carView.bottomAnchor, constant: 5),
        priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        smallLabelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        largeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        largeLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
        detailLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
        carView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
    ].flatMap({ $0 })
    compactConstraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "H:[smallLabelView]", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[carView(70)]-12-[priceLabel]-2-[timeLabel]-15-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:[carView]", options: [], metrics: nil, views: views),
      ].flatMap({ $0 })
    
    expandedConstraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "H:[smallLabelView(14)]", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[carView(105)]-20-[largeLabel]-10-[detailLabel]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:[carView]", options: [], metrics: nil, views: views),
      ].flatMap({ $0 })
    
    NSLayoutConstraint.activate(permanentConstraints)
  }

}
