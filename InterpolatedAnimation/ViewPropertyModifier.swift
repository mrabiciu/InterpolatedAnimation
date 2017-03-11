//
//  ViewPropertyModifier.swift
//  Animation
//
//  Created by Max on 2/25/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import Foundation
import UIKit

/// Represents the state of a specific property of a view
protocol ViewPropertyModifier: Interpolated, Equatable {
  associatedtype T: Interpolated, Equatable
  var value: T { get set }
  func apply(to view: UIView)
  init(_ view: UIView)
  init()
}

extension ViewPropertyModifier  {
  init(value: T) {
    self.init()
    set(value: value)
  }
  mutating func set(value: T) {
    self.value = value
  }
  static func interpolated(from: Self, to: Self, percent: Double) -> Self {
    return self.init(value: interpolate(from: from.value, to: to.value, percent: percent))
  }
}
func ==<T : ViewPropertyModifier>(lhs: T, rhs: T) -> Bool { return lhs.value == rhs.value }

struct FrameModifier: ViewPropertyModifier {
  var value: CGRect = .zero
  internal func apply(to view: UIView) { view.frame = value }
  init(_ view: UIView) { value = view.frame }
  init() {}
}


struct BackgroundColorModifier: ViewPropertyModifier {
  var value: UIColor = .clear
  internal func apply(to view: UIView) { view.backgroundColor = value }
  init(_ view: UIView) { value = view.backgroundColor ?? .clear }
  init() {}
}

struct AlphaModifier: ViewPropertyModifier {
  var value: CGFloat = 0
  internal func apply(to view: UIView) { view.alpha = value }
  init(_ view: UIView) { value = view.alpha }
  init() {}
}

struct TransformModifier: ViewPropertyModifier {
  var value: CGAffineTransform = .identity
  internal func apply(to view: UIView) { view.transform = value }
  init(_ view: UIView) { value = view.transform }
  init() {}
}

/// A type erased ViewPropertyModifier
struct AnyViewPropertyModifier: Interpolated, Equatable {
  let modifier: Any
  let _interpolate: ((AnyViewPropertyModifier, Double) -> AnyViewPropertyModifier)
  let _apply: (UIView) -> Void
  let isEqualTo: (AnyViewPropertyModifier) -> Bool
  
  init<T: ViewPropertyModifier>(_ modifier: T) {
    self.modifier = modifier
    _interpolate = { to, percent in
      guard let toModifier = to.modifier as? T else { return AnyViewPropertyModifier(modifier) }
      return AnyViewPropertyModifier(T.interpolated(from: modifier, to: toModifier, percent: percent))
    }
    _apply = { view in
      modifier.apply(to: view)
    }
    
    isEqualTo = { otherVal in
      guard let otherModifier = otherVal.modifier as? T else { return false }
      return modifier == otherModifier
    }
  }
  
  func apply(to view: UIView) {
    _apply(view)
  }
  
  static func interpolated(from: AnyViewPropertyModifier, to: AnyViewPropertyModifier, percent: Double) -> AnyViewPropertyModifier {
    return from._interpolate(to, percent)
  }
}
func ==(lhs: AnyViewPropertyModifier, rhs: AnyViewPropertyModifier) -> Bool { return lhs.isEqualTo(rhs) }




