//
//  VideoPicker.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import AVFoundation
import Foundation
import SwiftUI

struct VideoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showVideoPicker: Bool
    @Binding var videoURL: URL
    @StateObject var viewModel: DanceVisionVM

    var allowsEditing = true
    var videoMaximumDuration: TimeInterval = 15

    typealias UIViewControllerType = UIImagePickerController

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = context.coordinator
        myPickerController.sourceType = .savedPhotosAlbum
        myPickerController.allowsEditing = allowsEditing
        myPickerController.mediaTypes = ["public.movie"]
        myPickerController.videoQuality = .typeHigh
        myPickerController.videoMaximumDuration = 30
        myPickerController.videoExportPreset = AVAssetExportPreset1280x720

        return myPickerController
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {
        //
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[.mediaURL] as? URL {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.parent.viewModel.videoURL = url
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.showVideoPicker = false
        }
    }
}
