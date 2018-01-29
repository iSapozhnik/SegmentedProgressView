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
        static let defaultItemSpace: CGFloat = 6.0
    }
    
    public weak var delegate: ProgressBarDelegate?
    
//    override public var frame: CGRect {
//        didSet {
//            redraw()
//        }
//    }
    
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
    
    public var itemSpace: CGFloat = Config.defaultItemSpace {
        didSet {
            redraw()
        }
    }
    
    public var items: [ProgressItem]? {
        didSet {
            draw()
        }
    }
    
    var elementViews: [SegmentView] = []
    
    // MARK: - Public
    
    public init(withItems items: [ProgressItem]!) {
        self.items = items
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    
    private var segmentsContainer: UIStackView!
    
    fileprivate func setup() {
        setupViews()
        setupConstraints()
    }
    
    fileprivate func setupViews() {
        self.backgroundColor = .clear

        segmentsContainer = UIStackView()
        segmentsContainer.spacing = itemSpace
        addSubview(segmentsContainer)
    }
    
    fileprivate func setupConstraints() {
        segmentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentsContainer.topAnchor.constraint(equalTo: self.topAnchor),
            segmentsContainer.rightAnchor.constraint(equalTo: self.rightAnchor),
            segmentsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            segmentsContainer.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    fileprivate func redraw() {
//        clear()
//        draw()
    }
    
    fileprivate func clear() {
        
//        elementViews.removeAll()
//        for view in subviews {
//            view.removeFromSuperview()
//        }
    }
    
    fileprivate func draw() {
        guard let items = self.items, items.count > 0 else { return }

        var firstElement: SegmentView?
        
        elementViews = items.map { item -> SegmentView in
            let elementView = SegmentView(withItem: item)

            elementView.progressTintColor = self.progressTintColor
            elementView.trackTintColor = self.trackTintColor
            elementView.delegate = self
            elementView.drawEmpty()
            elementView.translatesAutoresizingMaskIntoConstraints = false
            
            segmentsContainer.addArrangedSubview(elementView)
            
            if (firstElement != nil) {
                elementView.widthAnchor.constraint(equalTo: firstElement!.widthAnchor).isActive = true
            }
            firstElement = elementView

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
