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
    
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    
    private var thumbView: SegmentThumbView!
    private var thumbViewLeadingConstraint: NSLayoutConstraint!
    
    private var emptyShape = CAShapeLayer()
    private var filledShape = CAShapeLayer()
    
    init(withItem item: ProgressItem!) {
        self.item = item
        super.init(frame: .zero)
        setupLayer()
        setupThumbView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        layer.addSublayer(emptyShape)
        layer.addSublayer(filledShape)
    }
    
    func drawEmpty() {
        let emptyColor = trackTintColor ?? .lightGray
        let fillColor = progressTintColor ?? .gray

        emptyShape.backgroundColor = emptyColor.cgColor
        filledShape.fillColor = fillColor.cgColor
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        emptyShape.frame = self.bounds
        emptyShape.cornerRadius = bounds.height / 2
    }
    
    func setupThumbView() {
        let thumbView = SegmentThumbView(radius: 10)
        addSubview(thumbView)
        
        self.thumbView = thumbView
        setupConstraints()
    }
    
    func setupConstraints() {
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbViewLeadingConstraint = thumbView.leftAnchor.constraint(equalTo: self.leftAnchor)
        NSLayoutConstraint.activate([
            thumbView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbView.heightAnchor.constraint(equalToConstant: thumbView.radius * 2),
            thumbView.widthAnchor.constraint(equalToConstant: thumbView.radius * 2),
            thumbViewLeadingConstraint
        ])
    }
    
    func animate() {
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height), cornerRadius: bounds.height / 2).cgPath
        let endPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        
        filledShape.path = startPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            if self.item.state == ProgressState.playing {
                self.delegate?.progressBar(didFinishWithItem: self.item)
                self.item.handler?()
                self.thumbView.hide()
            }
        })
        
        let fillAnimation = CABasicAnimation(keyPath: "path")
        fillAnimation.toValue = endPath.cgPath
        fillAnimation.duration = self.item.duration
        fillAnimation.repeatCount = 1
        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        fillAnimation.fillMode = kCAFillModeBoth
        fillAnimation.isRemovedOnCompletion = false
        
        filledShape.add(fillAnimation, forKey: fillAnimation.keyPath)

        thumbViewLeadingConstraint.constant = bounds.width - 2 * thumbView.radius
        UIView.animate(withDuration: item.duration, delay: 0.0, options: [.curveLinear], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func play() {
        if item.state == .playing { return }
        
        if item.state == ProgressState.paused {
            resume()
        } else {
            thumbView.show()
            self.animate()
        }
        item.state = ProgressState.playing
    }
    
    func pause() {
        self.item.state = ProgressState.paused
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func stop() {
        
        thumbView.layer.removeAllAnimations()
        thumbViewLeadingConstraint.constant = 0.0

        thumbView.hide() { [weak self] in
            self?.layoutIfNeeded()
        }
        resume()
        item.state = ProgressState.finished
        filledShape.path = nil
        filledShape.removeAllAnimations()
        drawEmpty()
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
