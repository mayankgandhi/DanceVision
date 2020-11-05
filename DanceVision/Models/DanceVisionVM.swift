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
    let model = WAP()
    var allPoses: [VNRecognizedPointsObservation] = []
    
    var videoURL: URL? {
        didSet {
            getPoses(videoURL!)
            isWAP()
        }
    }
    
    @Published var items: [PredictedItem] = []
    
    @Published var showToast: Bool = false
    var toastType = ToastType.success(message: "good")
    
    func isWAP() {
        do {
            let poses = allPoses.prefix(360).map { x in x }
            guard let output = (try makePrediction(posesWindow: poses)) else { return }
            let stats = output.featureValue(for: "labelProbabilities")!
            let wap = Int(stats.dictionaryValue["WAP"]!.floatValue * 100)
            let other = Int(stats.dictionaryValue["Other"]!.floatValue * 100)
            items.append(PredictedItem(videoURL: videoURL!, wapVal: String(wap), otherVal: String(other)))
            allPoses.removeAll()
        } catch {
            DispatchQueue.main.async { [self] in
                toastType = .error(message: error.localizedDescription)
                showToast = true
                print(error.localizedDescription)
            }
        }
    }
    
    func getPoses(_ url: URL) {
        let request = VNDetectHumanBodyPoseRequest(completionHandler: { [self] request, _ in
            let poses = request.results as! [VNRecognizedPointsObservation]
            allPoses.append(contentsOf: poses)
        })
        
        let processor = VNVideoProcessor(url: url)
        let videoDuration = AVAsset(url: url).duration
        
        DispatchQueue.main.async { [self] in
            if !(videoDuration.seconds > 11 && videoDuration.seconds < 30) {
                toastType = .warning(message: "Selected Dance Video needs to be between 11 and 30 seconds.")
                showToast = true
            }
        }
        
        do {
            let range = CMTimeRange(start: CMTime.zero, duration: videoDuration)
            try processor.add(request)
            try processor.analyze(range)
        } catch {
            DispatchQueue.main.async { [self] in
                toastType = .error(message: error.localizedDescription)
                showToast = true
                print(error.localizedDescription)
            }
        }
    }
    
    /// Make a model prediction on a window.
    func makePrediction(posesWindow: [VNRecognizedPointsObservation]) throws -> MLFeatureProvider? {
        // Prepare model input: convert each pose to a multi-array, and concatenate multi-arrays.
        let poseMultiArrays: [MLMultiArray] = try posesWindow.map { person in
            try! person.keypointsMultiArray()
        }
        
        let modelInput = MLMultiArray(concatenating: poseMultiArrays, axis: 0, dataType: .float)
        
        var predictions: MLFeatureProvider?
        do {
            // Perform prediction
            predictions = try model.prediction(poses: modelInput)
        } catch {
            DispatchQueue.main.async { [self] in
                toastType = .error(message: error.localizedDescription)
                showToast = true
            }
        }
        
        return predictions
    }
}
