//
//  ASTimerCallback.swift
//  DJme
//
//  Created by Ankit Saini on 05/10/20.
//  Copyright © 2020 softobiz. All rights reserved.
//

import Foundation

/// Callback class for timers
class ASTimerCallback: NSObject {
    
    /// Queue One
    private let queueOne = DispatchQueue(label: "com.ankit.queue_astimer_one", qos: .background)
    
    /// Queue Two
    private let queueTwo = DispatchQueue(label: "com.ankit.queue_astimer_two", qos: .background)
    
    /// Queue Three
    private let queueThree = DispatchQueue(label: "com.ankit.queue_astimer_three", qos: .background)
    
    /// Timer for completion Handler
    var timer: ASTimer?
    
    /// Start the timer for interval.
    /// - Parameters:
    ///   - interval: value of callback interval
    ///   - timeType: Type of time interval -> timeType == 1 'seconds', timeType == 2 'Mili-Seconds'
    ///   - queue: In Which Queue to start time: 0-> 'default', 1-> 'Queue 1', 2-> 'Queue 2'
    ///   - completion: ()
    @objc init(interval: Int, timeType: Int = 1, queueType: Int, completion: @escaping() -> Void) {
        if self.timer != nil {
            print("ASTimer Callback already running")
            completion()
            return
        }
        
        ///
        /// Set Time Interval
        ///
        var dispatchtime: DispatchTimeInterval = .never
        if timeType == 1 { /// Seconds
            dispatchtime = .seconds(interval)
        } else if timeType == 2 { /// Mili-Seconds
            dispatchtime = .milliseconds(interval)
        } else {
            dispatchtime = .seconds(interval)
        }
        ///
        /// Set Queue
        ///
        var queue: DispatchQueue?
        if queueType == 1 {
            queue = self.queueOne
        } else if queueType == 2 {
            queue = self.queueTwo
        } else if queueType == 3 {
            queue = self.queueThree
        }
        
        self.timer = ASTimer.init(timeInterval: dispatchtime, queue: queue)
        self.timer?.eventHandler = {
//            print("Callback Timer Fired")
            autoreleasepool(invoking: {
                kMainQueue.async {
                    completion()
                }
            })
        }
        self.timer?.resume()
    }
    
    /// Reset the timer to invalidate
    @objc func resetCallbackTimer() {
        if self.timer != nil {
            self.timer?.suspend()
            self.timer = nil
            print("Callback timer stopped")
        }
    }
}
