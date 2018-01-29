//
//  SegmentedProgressView.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import Foundation

protocol Animatable {
    func play()
    func pause()
    func stop()
}

extension ProgressItem: Animatable {
    func play() {
        self.associatedView?.play()
    }
    
    func pause() {
        self.associatedView?.pause()
    }
    
    func stop() {
        self.associatedView?.stop()
    }
}

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
        if currentItem == nil {
            guard let item = items?[0] else {
                return
            }
            item.play()
            delegate?.progressBar(willDisplayItemAtIndex: 0, item: item)
            currentItem = item
        } else {
            currentItem?.play()
        }
    }
    
    public func pause() {
        currentItem?.pause()
    }
    
    public func stop() {
        clear()
    }
    
    // MARK: - Private
    
    private var segmentsContainer: UIStackView!
    private var currentItem: ProgressItem?
    
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
        
        items.forEach { item in
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
            item.associatedView = elementView
        }

    }
    
    public func progressBar(didFinishWithItem item: ProgressItem) {
        guard let items = self.items else { return }
        
        if var index = items.index(of: item) {
            
            delegate?.progressBar(didDisplayItemAtIndex: index, item: item)
            
            index += 1
            
            if index < items.count {
                let nextItem = items[index]
                delegate?.progressBar(willDisplayItemAtIndex: index, item: nextItem)
                nextItem.play()
                currentItem = nextItem
            }
        }
    }
}
