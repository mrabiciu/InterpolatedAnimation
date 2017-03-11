//
//  DrawerView.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

class DrawerView: UIView {
  let detailView1 = DetailView()
  let detailView2 = DetailView()
  let detailViewContainer = UIView()
  let buttonContainer = ButtonContainerView()
  let detailInfoView = DetailInfoView()
  
  var state: State = .compact {
    didSet { move(to: state) }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(detailViewContainer)
    addSubview(buttonContainer)
    addSubview(detailInfoView)
    [detailView1, detailView2].forEach { view in
      detailViewContainer.addSubview(view)
    }
    detailView1.smallLabelView.alpha = 0
    installConstraints()
    move(to: state)
    detailInfoView.alpha = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var compactConstraints: [NSLayoutConstraint] = []
  private var expandedConstraints: [NSLayoutConstraint] = []
  private func installConstraints() {
    var views: [String: UIView] = ["detailView1": detailView1, "detailView2": detailView2, "detailViewContainer": detailViewContainer, "buttonContainer": buttonContainer, "detailInfoView": detailInfoView]
    views.forEach { _, view in
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    views["self"] = self
    
    let permanentConstraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailViewContainer]|", options: [], metrics: nil, views: views),
      

      NSLayoutConstraint.constraints(withVisualFormat: "V:|[detailView1]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[detailView2]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[buttonContainer]-15-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailInfoView]|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:[detailViewContainer]-50-[detailInfoView]", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "H:[detailView1][detailView2(detailView1)]", options: [], metrics: nil, views: views),
      
      
      ].flatMap({ $0 })
    
    expandedConstraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[detailViewContainer]", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:[detailInfoView(230)]|", options: [], metrics: nil, views: views),
      
      NSLayoutConstraint.constraints(withVisualFormat: "H:[detailView1(self)][detailView2(self)]", options: [], metrics: nil, views: views),
      

      [
        detailView2.centerXAnchor.constraint(equalTo: centerXAnchor),
       buttonContainer.centerYAnchor.constraint(equalTo: bottomAnchor)]
      ].flatMap({ $0 })
    
    compactConstraints = [
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-55-[detailView1][detailView2(detailView1)]-55-|", options: [], metrics: nil, views: views),
      NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[detailViewContainer]-5-[buttonContainer]-15-|", options: [], metrics: nil, views: views),
      [
        detailInfoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
      ]
    ].flatMap({ $0 })
    
    NSLayoutConstraint.activate(permanentConstraints)
  }
  
  private func move(to state: State) {
    detailView2.state = state
    switch state {
    case .compact:
      NSLayoutConstraint.deactivate(expandedConstraints)
      NSLayoutConstraint.activate(compactConstraints)
    case .expanded:
      NSLayoutConstraint.deactivate(compactConstraints)
      NSLayoutConstraint.activate(expandedConstraints)
    }
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
//    print(self.constraints)
  }
  
  override func setNeedsLayout() {
    super.setNeedsLayout()
  }
  
  override var frame: CGRect {
    didSet {
    }
  }
}
