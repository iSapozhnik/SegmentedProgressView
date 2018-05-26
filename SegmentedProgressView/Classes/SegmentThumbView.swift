//
//  SegmentThumbView.swift
//  Pods-SegmentedProgressView_Example
//
//  Created by Ivan Sapozhnik on 5/26/18.
//

import Foundation

class SegmentThumbView: UIView {
    private(set) var radius: CGFloat
    private(set) var shapeLayer: CAShapeLayer!
    
    init(radius: CGFloat) {
        self.radius = radius
        
        let frame = CGRect(x: 0.0, y: 0.0, width: radius * 2, height: radius * 2)
        super.init(frame: frame)
        
        backgroundColor = .clear
        alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect)

        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.red.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    func show() {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        alpha = 1.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: {
            self.transform =  CGAffineTransform(scaleX: 0.3, y: 0.3)
        }) { _ in
            self.alpha = 0.0
            completion?()
        }
    }
    
    deinit {
        
    }
}
