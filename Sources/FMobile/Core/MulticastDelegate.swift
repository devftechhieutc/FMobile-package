//
//  MulticastDelegate.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//

import Foundation

internal class MulticastDelegate<T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    internal func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    internal func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects.reversed() {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }

    internal func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}
