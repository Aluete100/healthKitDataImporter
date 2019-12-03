//
//  SharedMemory.swift
//  HealthKitDataSeeds
//
//  Created by Alan Antar on 10/31/19.
//  Copyright © 2019 Alan Antar. All rights reserved.
//

import Foundation

class SharedMemory: NSObject {

    static let global = SharedMemory()

    let preferences = UserDefaults.standard
    let helper: SharedMemoryHelper

    // Main
    private var mHKDataUrl: String?

    override init() {
        helper = SharedMemoryHelper()
    }

    var hkDataUrl: String? {
        get {
            mHKDataUrl = helper.getObject(key: "dataURL", internalObject: mHKDataUrl) as? String
            return mHKDataUrl
        }
        set {
            mHKDataUrl = newValue
            helper.setObject(key: "dataURL", internalObject: mHKDataUrl)
        }
    }
}
