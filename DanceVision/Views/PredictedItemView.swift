//
//  PredictedItemView.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import SwiftUI

struct PredictedItemView: View {
    struct PredictionIndicator: View {
        let title: String
        let value: String

        var body: some View {
            VStack(spacing: 0) {
                Text(title.uppercased())
                    .font(.caption).bold()
                Text(value)
                    .font(.title2)
                    .bold()
                    .padding()
                    .background(Color.red)
                    .clipShape(Circle())
                    .padding(.all, 5)
            }
        }
    }

    let predictedItem: PredictedItem

    var WAPIndicator: some View {
        VStack(alignment: .center, spacing: 0) {
            PredictionIndicator(title: "WAP", value: predictedItem.wapVal)
            PredictionIndicator(title: "Not WAP", value: predictedItem.otherVal)
        }
    }

    var body: some View {
        if predictedItem.wapVal == "loader" {
            Text("Loader")
        } else {
            HStack(alignment: .center, spacing: 0) {
                VideoPlayer(videoURL: predictedItem.videoURL)
                    .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 4, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                WAPIndicator
            }
            .background(BlurView(.light))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .shadow(radius: 10)
        }
    }
}
