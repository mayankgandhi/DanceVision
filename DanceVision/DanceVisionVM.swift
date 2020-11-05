//
//  DanceVisionVM.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import AVFoundation
import CoreML
import Foundation
import Vision

class DanceVisionVM: ObservableObject {
//    static let shared = DanceVisionVM()
    
    let model = WAP()
    var allPoses: [VNRecognizedPointsObservation] = []
    
    @Published var wapVal: String = "0%"
    @Published var otherVal: String = "0%"

    func isWAP() {
        do {
            let poses = allPoses.prefix(360).map { x in x }
            let output = (try makePrediction(posesWindow: poses))
            let stats = output.featureValue(for: "labelProbabilities")!
            let wap: Int = Int(stats.dictionaryValue["WAP"]!.floatValue * 100)
            wapVal = String(wap) + "%"
            let other: Int = Int(stats.dictionaryValue["Other"]!.floatValue * 100)
            otherVal = String(other) + "%"
        } catch {
            print(error)
        }
    }

    func getPoses(_ url: URL) {
        let avAsset = AVAsset(url: url)

        let request = VNDetectHumanBodyPoseRequest(completionHandler: { [self] request, _ in
            let poses = request.results as! [VNRecognizedPointsObservation]
            allPoses.append(contentsOf: poses)
            print("done")
        })

        let processor = VNVideoProcessor(url: url)

        do {
            let range = CMTimeRange(start: CMTime.zero, duration: avAsset.duration)
            try processor.add(request)
            try processor.analyze(range)
        } catch {
            print(error)
        }
    }

    /// Make a model prediction on a window.
    func makePrediction(posesWindow: [VNRecognizedPointsObservation]) throws -> MLFeatureProvider {
        print(posesWindow.count)
        // Prepare model input: convert each pose to a multi-array, and concatenate multi-arrays.
        let poseMultiArrays: [MLMultiArray] = try posesWindow.map { person in
            try person.keypointsMultiArray()
        }

        let modelInput = MLMultiArray(concatenating: poseMultiArrays, axis: 0, dataType: .float)

        // Perform prediction
        let predictions = try model.prediction(poses: modelInput)

        return predictions
    }
}
