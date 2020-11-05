//
//  DanceVisionVM.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import Foundation
import CoreML
import Vision
import AVFoundation

class DanceVisionVM: ObservableObject {
    
    static let shared = DanceVisionVM()

    let model = WAP()
    var allPoses: [VNRecognizedPointsObservation] = []
    
    init() {
        //
    }
    
    func isWAP() {
        do {
            let poses = self.allPoses.prefix(360).map { x in
                return x
            }
           let output = ( try makePrediction(posesWindow: poses) )
            print(output.featureValue(for: "labelProbabilities"))
        } catch {
            print(error)
        }
    }
    
    func getPoses(_ url: URL) {
        
        let avAsset = AVAsset(url: url)
        
        let request = VNDetectHumanBodyPoseRequest(completionHandler: { [self] request, error in
            let poses = request.results as! [VNRecognizedPointsObservation]
            allPoses.append(contentsOf: poses)
        })
        
        let processor = VNVideoProcessor(url: url)
        
        do {
            try processor.add(request)
            let range = CMTimeRange(start: CMTime.zero, duration: avAsset.duration)
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
            return try person.keypointsMultiArray()
          }

          let modelInput = MLMultiArray(concatenating: poseMultiArrays, axis: 0, dataType: .float)

          // Perform prediction
          let predictions = try model.prediction(poses: modelInput)
        
          return predictions
      }
    
}
