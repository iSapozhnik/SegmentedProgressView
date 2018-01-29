//
//  ProgressItem.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import Foundation

public enum ProgressState {
    case playing
    case paused
    case finished
    case none
}

public class ProgressItem: Equatable {
    
    public typealias CompletionHanlder = () -> ()
    
    let duration: Double!
    let handler: CompletionHanlder?
    
    var sate: ProgressState! = .none
    weak var associatedView: SegmentView?
    
    public init(withDuration duration: Double, handler completion: CompletionHanlder? = nil) {
        self.duration = duration
        self.handler = completion
    }
    
    public static func ==(lhs: ProgressItem, rhs: ProgressItem) -> Bool {
        return lhs.associatedView == rhs.associatedView &&
            lhs.duration == rhs.duration
    }
}
