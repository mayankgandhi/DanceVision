//
//  PredictedItem.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import Foundation

struct PredictedItem: Identifiable, Hashable {
    let videoURL: URL
    let wapVal: String
    let otherVal: String
    
    public var id: String { videoURL.absoluteString }
    
    static var empty: PredictedItem {
        PredictedItem(videoURL: URL(fileURLWithPath: "https://www.google.com"), wapVal: "-1", otherVal: "-1")
    }
}
