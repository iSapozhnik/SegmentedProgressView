//
//  SegmentView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import UIKit

public protocol ProgressBarDelegate: class {
    
    func progressBar(willDisplayItemAtIndex index: Int, item: ProgressItem)
    func progressBar(didDisplayItemAtIndex index: Int, item: ProgressItem)

}

public protocol ProgressBarElementViewDelegate: class {
    
    func progressBar(didFinishWithItem item: ProgressItem)

}

public class SegmentView: UIView, Animatable {
    
    weak var delegate: ProgressBarElementViewDelegate?
    var item: ProgressItem
//    var sate: ProgressState! = .none
    
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    
    private var emptyShape = CAShapeLayer()
    
    init(withItem item: ProgressItem!) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawEmpty() {
        
        let emptyColor = trackTintColor ?? .lightGray
        emptyShape.backgroundColor = emptyColor.cgColor
        self.layer.addSublayer(emptyShape)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        emptyShape.frame = self.bounds
        emptyShape.cornerRadius = bounds.height / 2
    }
    
    func animate() {
        
        let fillColor = progressTintColor ?? .gray
        
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height), cornerRadius: bounds.height / 2).cgPath
        let endPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        
        let filledShape = CAShapeLayer()
        filledShape.path = startPath
        filledShape.fillColor = fillColor.cgColor
        self.layer.addSublayer(filledShape)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.delegate?.progressBar(didFinishWithItem: self.item)
            self.item.handler?()
        })
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath.cgPath
        animation.duration = self.item.duration
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        
        filledShape.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
    
    func play() {
        if item.sate == ProgressState.paused {
            resume()
        } else {
            self.item.sate = ProgressState.playing
            self.animate()
        }
    }
    
    func pause() {
        self.item.sate = ProgressState.paused
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func stop() {
        self.item.sate = ProgressState.finished
    }
    
    private func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
