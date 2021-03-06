//
//  Functions.swift
//  MyLocations
//
//  Created by Norman Lopez on 5/17/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//
import Foundation
import Dispatch


/*
 
 The -> symbol means that the type represents a closure. The type for a closure generally looks like this:
 (parameter list) -> return type
 
 This can
 also be written as Void -> Void
 
 
 */

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds,
                                  execute: closure)
}


let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
}()

let MyManagedObjectContextSaveDidFailNotification = Notification.Name(
    rawValue: "MyManagedObjectContextSaveDidFailNotification")
func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(
        name: MyManagedObjectContextSaveDidFailNotification, object: nil)
}
