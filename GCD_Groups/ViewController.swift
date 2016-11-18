//
//  ViewController.swift
//  GCD_Groups
//
//  Created by Franks, Kent Eric on 10/27/16.
//  Copyright © 2016 KefBytes. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    let queue:DispatchQueue	= DispatchQueue.global(qos: .userInitiated)
    let group:DispatchGroup	= DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - actions
    @IBAction func startAction(_ sender: AnyObject) {
        
        print("🎾KefBytes: Service calls started")
        
        // call the normal service
        group.enter()
        queue.async {
            print("🎾KefBytes: Normal service called")
            self.normalServiceCall(delay: 5) {
                print("🎾KefBytes: Normal service returned")
                self.group.leave()
            }
        }

        // call the slow service
        group.enter()
        queue.async {
            print("🎾KefBytes: Slow service called")
            self.slowServiceCall(delay: 5) {
                print("🎾KefBytes: Slow service returned")
                self.group.leave()
            }
        }

        // call the quick service
        group.enter()
        queue.async {
            print("🎾KefBytes: Quick service called")
            self.quickServiceCall(delay: 5) {
                print("🎾KefBytes: Quick service returned")
                self.group.leave()
            }
        }
        
        // notify will get called when all tasks in group complete
        group.notify(queue: queue, execute: {print("🎾KefBytes: All Service calls returned successfully")})

        print("🎾KefBytes: Service calls are in process")

        // code after wait will execute after all tasks in group will complete
        let _ = group.wait()
        print("🎾KefBytes: Service calls completed")
        

    }
    
    // MARK: - service call simulated functions
    func quickServiceCall(delay: Int, callBack: @escaping ()->()) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(delay), execute: callBack)
    }
    
    func normalServiceCall(delay: Int, callBack: @escaping ()->()) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(delay * 3), execute: callBack)
    }

    func slowServiceCall(delay: Int, callBack: @escaping ()->()) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(delay * 6), execute: callBack)
    }

}

