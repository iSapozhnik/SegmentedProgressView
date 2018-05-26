//
//  ViewController.swift
//  SegmentedProgressView
//
//  Created by isapozhnik on 05/12/2017.
//  Copyright (c) 2017 isapozhnik. All rights reserved.
//

import UIKit
import SegmentedProgressView

class ViewController: UIViewController, ProgressBarDelegate {

    var items: [ProgressItem] = []
    
    @IBOutlet weak var xibProgressView: SegmentedProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = []
        for _ in 0...3 {
            items.append(ProgressItem(withDuration: 5))
        }
        xibProgressView.delegate = self
        xibProgressView.progressTintColor = UIColor(red: 66.0/255.0, green: 134.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        xibProgressView.trackTintColor = UIColor(red: 133/255.0, green: 169/255.0, blue: 229/255.0, alpha: 1.0)
        xibProgressView.itemSpace = 6.0
        xibProgressView.items = items
        
    }
    
    func progressBar(willDisplayItemAtIndex index: Int, item: ProgressItem) {
        print("willDisplayItemAtIndex \(index)")
    }
    
    func progressBar(didDisplayItemAtIndex index: Int, item: ProgressItem) {
        print("didDisplayItemAtIndex \(index)")
    }
    
    @IBAction func onPlay(_ sender: Any) {
        xibProgressView.play()
    }
    
    @IBAction func onPause(_ sender: Any) {
        xibProgressView.pause()
    }
    
    @IBAction func onStop(_ sender: Any) {
        xibProgressView.stop()
    }
}

