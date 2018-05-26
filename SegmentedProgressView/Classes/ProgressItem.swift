//
//  ProgressItem.swift
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
        startCountingProgress()
        self.associatedView?.play()
    }
    
    func pause() {
        self.associatedView?.pause()
    }
    
    func stop() {
        stopCountingProgress()
        self.associatedView?.stop()
    }
}

public enum ProgressState {
    case playing
    case paused
    case finished
    case none
}

public class ProgressItem: Equatable {
    
    public typealias CompletionHanlder = () -> Void
    
    let duration: Double!
    let handler: CompletionHanlder?
    
    var state: ProgressState
    var progress: Double = 0.0
    
    weak var associatedView: SegmentView?
    
    private var timer: Timer?
    private var timeInterval: TimeInterval = 0.0
    
    public init(withDuration duration: Double, handler completion: CompletionHanlder? = nil, state: ProgressState = .none) {
        self.duration = duration
        self.handler = completion
        self.state = state
    }
    
    public static func ==(lhs: ProgressItem, rhs: ProgressItem) -> Bool {
        return lhs.associatedView == rhs.associatedView &&
            lhs.duration == rhs.duration &&
            lhs.progress == rhs.progress
    }
    
    func startCountingProgress() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(countProgress), userInfo: nil, repeats: true)
    }
    
    func pauseCountingProgress() {
        timer?.invalidate()
    }
    
    func stopCountingProgress() {
        timer?.invalidate()
        timeInterval = 0.0
        progress = 0.0
    }
    
    @objc private func countProgress() {
        timeInterval += 0.01
        progress = timeInterval / self.duration
    }
}
