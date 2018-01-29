//
//  SegmentedProgressView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import Foundation

public class SegmentedProgressView: UIView, ProgressBarElementViewDelegate {
    
    struct Config {
        static let defaultItemSpace: Double = 6.0
    }
    
    public weak var delegate: ProgressBarDelegate?
    
    override public var frame: CGRect {
        didSet {
            redraw()
        }
    }
    
    public var progressTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var trackTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var itemSpace: Double = Config.defaultItemSpace {
        didSet {
            redraw()
        }
    }
    
    public var items: [ProgressItem]? {
        didSet {
            redraw()
        }
    }
    
    var elementViews: [SegmentView] = []
    
    // MARK: - Public
    
    public init(withItems items: [ProgressItem]!) {
        self.items = items
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    public func play() {
        let elementView = elementViews[0]
        delegate?.progressBar(willDisplayItemAtIndex: 0)
        elementView.animate()
    }
    
    public func pause() {
        
    }
    
    public func stop() {
        clear()
    }
    
    // MARK: - Private
    
    fileprivate func redraw() {
        clear()
        draw()
    }
    
    fileprivate func clear() {
        
        elementViews.removeAll()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func draw() {
        guard let items = self.items, items.count > 0 else { return }
        
        var elementWidth = ((Double(bounds.width) + itemSpace) / Double(items.count))
        elementWidth -= itemSpace
        
        if elementWidth <= 0 { return }
        
        var xOffset: Double = 0.0

        elementViews = items.map { item -> SegmentView in
            let elementView = SegmentView(withItem: item)
            elementView.progressTintColor = self.progressTintColor
            elementView.trackTintColor = self.trackTintColor
            elementView.delegate = self
            elementView.frame = CGRect(x: xOffset, y: 0, width: elementWidth, height: Double(bounds.height))
            elementView.drawEmpty()
            
            self.addSubview(elementView)
            xOffset += elementWidth + itemSpace
            
            return elementView
        }
    }
    
    public func progressBar(didFinishWithElement element: SegmentView) {
        guard let items = self.items else { return }
        
        if var index = elementViews.index(of: element) {
            
            delegate?.progressBar(didDisplayItemAtIndex: index)
            
            index += 1
            
            if index < items.count {
                let elementView = elementViews[index]
                delegate?.progressBar(willDisplayItemAtIndex: index)
                elementView.animate()
            }
        }
    }
}
