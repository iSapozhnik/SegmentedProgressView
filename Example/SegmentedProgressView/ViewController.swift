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
        
//        for _ in 0...4 {
//            items.append(ProgressItem(withDuration: 3))
//        }
        
//        let elementWithCompletion = ProgressItem(withDuration: 3) {
//            print("elementWithCompletion finished")
//        }
        
//        items.append(elementWithCompletion)
        
        var progressView = SegmentedProgressView(withItems: items)
        progressView.delegate = self
        progressView.backgroundColor = .white
        progressView.itemSpace = 3.0
        progressView.frame = CGRect(x: 20, y: 60, width: view.bounds.width - 40, height: 4)
        view.addSubview(progressView)
        
        items = []
        for _ in 0...10 {
            items.append(ProgressItem(withDuration: 4))
        }
        
        progressView = SegmentedProgressView(withItems: items)
        progressView.progressTintColor = UIColor(red: 66.0/255.0, green: 134.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        progressView.trackTintColor = UIColor(red: 133/255.0, green: 169/255.0, blue: 229/255.0, alpha: 1.0)

        progressView.delegate = self
        progressView.backgroundColor = .white
        progressView.itemSpace = 4.0
        progressView.frame = CGRect(x: 20, y: 80, width: view.bounds.width - 40, height: 2)
        view.addSubview(progressView)
        
        items = []
        for _ in 0...4 {
            items.append(ProgressItem(withDuration: 3))
        }
        xibProgressView.delegate = self
        xibProgressView.progressTintColor = UIColor(red: 66.0/255.0, green: 134.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        xibProgressView.trackTintColor = UIColor(red: 133/255.0, green: 169/255.0, blue: 229/255.0, alpha: 1.0)
        xibProgressView.itemSpace = 6.0
        xibProgressView.items = items
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

