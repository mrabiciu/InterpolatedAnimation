//
//  ViewPropertyInterpolator.swift
//  Animation
//
//  Created by Max on 2/28/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

/// Contains a snapshot of a view property at a particular percent
typealias PropertyKeyFrame = (modifier: AnyViewPropertyModifier, percent: Double)

struct ViewPropertyInterpolator {
  private var frameKeyFrames: [PropertyKeyFrame] = []
  private var alphaKeyFrames: [PropertyKeyFrame] = []
  private var backgroundColorKeyFrames: [PropertyKeyFrame] = []
  private var transformKeyFrames: [PropertyKeyFrame] = []
  
  var isEmpty: Bool {
    return !allKeyFrames.contains(where: { !$0.isEmpty })
  }
  
  var hasFrameKeyFrames: Bool {
    return !frameKeyFrames.isEmpty
  }
  
  private var allKeyFrames: [[PropertyKeyFrame]] {
    return [transformKeyFrames, frameKeyFrames, alphaKeyFrames, backgroundColorKeyFrames]
  }
  
  init(_ view: UIView) {
    captureState(of: view, at: 0, captureMode: .exact)
  }
  
  /// Updates view's properties to values interpolated by percent
  func move(view: UIView, to percent: Double) {
    allKeyFrames.forEach {
      interpolatedModifier(from: $0, at: percent)?.apply(to: view)
    }
  }
  
  mutating func captureState(of view: UIView, at percent: Double, captureMode: InterpolatedAnimation.CaptureMode) {
    frameKeyFrames = insert(keyFrame: (modifier: AnyViewPropertyModifier(FrameModifier(view)), percent), into: frameKeyFrames, captureMode: captureMode)
    alphaKeyFrames = insert(keyFrame: (modifier: AnyViewPropertyModifier(AlphaModifier(view)), percent), into: alphaKeyFrames, captureMode: captureMode)
    backgroundColorKeyFrames = insert(keyFrame: (modifier: AnyViewPropertyModifier(BackgroundColorModifier(view)), percent), into: backgroundColorKeyFrames, captureMode: captureMode)
    transformKeyFrames = insert(keyFrame: (modifier: AnyViewPropertyModifier(TransformModifier(view)), percent), into: transformKeyFrames, captureMode: captureMode)
  }
  
  private func insert(keyFrame: PropertyKeyFrame, into propertyKeyframes: [PropertyKeyFrame], captureMode: InterpolatedAnimation.CaptureMode) -> [PropertyKeyFrame] {
    // If the capture mode is exact we capture all properties even they haven't changed
    if captureMode == .exact || keyFrame.modifier != interpolatedModifier(from: propertyKeyframes, at: keyFrame.percent) {
      let index = propertyKeyframes.insertionIndexOf(elem: keyFrame, isOrderedBefore: { $0.percent < $1.percent })
      var propertyKeyframes = propertyKeyframes
      if propertyKeyframes.count > index && propertyKeyframes[index].percent == keyFrame.percent {
        // If a modifier exists with this exact percen then we replace it
        propertyKeyframes[index] = keyFrame
      } else {
        // Otherwise just insert it into the array
        propertyKeyframes.insert(keyFrame, at: index)
      }
      return propertyKeyframes
    }
    return propertyKeyframes
  }
  
  /// Creates an interpolated value out of the passed in key frames
  private func interpolatedModifier(from keyFrames: [PropertyKeyFrame], at percent: Double) -> AnyViewPropertyModifier? {
    guard keyFrames.count > 1 else {
      return keyFrames.first?.modifier
    }
    var fromIndex = 0
    var toIndex = 1
    while keyFrames[toIndex].percent < percent && toIndex < keyFrames.count - 1 {
      fromIndex += 1
      toIndex += 1
    }
    let fromPercent = keyFrames[fromIndex].percent
    let toPercent = keyFrames[toIndex].percent
    return interpolate(from: keyFrames[fromIndex].modifier, to: keyFrames[toIndex].modifier, percent:(percent - fromPercent) /
      (toPercent - fromPercent))
    
  }
  
  /// Removes redundant keyFrames, if nothing changed then we don't store the modifier
  mutating func cleanup() {
    frameKeyFrames = cleanUp(keyFrames: frameKeyFrames)
    alphaKeyFrames = cleanUp(keyFrames: alphaKeyFrames)
    backgroundColorKeyFrames = cleanUp(keyFrames: backgroundColorKeyFrames)
    transformKeyFrames = cleanUp(keyFrames: transformKeyFrames)
  }
  
  /// Empties out the array if all values are the same
  private func cleanUp(keyFrames: [PropertyKeyFrame]) -> [PropertyKeyFrame] {
    if let first = keyFrames.first?.modifier,
      !keyFrames.dropFirst().contains { $0.modifier != first } {
      return []
    }
    return keyFrames
  }
}

// Shamelessly stolen from: http://stackoverflow.com/questions/26678362/how-do-i-insert-an-element-at-the-correct-position-into-a-sorted-array-in-swift
fileprivate extension Array {
  func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
    var lo = 0
    var hi = count - 1
    while lo <= hi {
      let mid = (lo + hi) / 2
      if isOrderedBefore(self[mid], elem) {
        lo = mid + 1
      } else if isOrderedBefore(elem, self[mid]) {
        hi = mid - 1
      } else {
        return mid // found at position mid
      }
    }
    return lo // not found, would be inserted at position lo
  }
}



