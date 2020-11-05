//
//  HomeView.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import SwiftUI

struct PredictionIndicator: View {
    
    let title: String
    @Binding var value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title.uppercased())
                .font(.caption)
            Text(value)
                .font(.title)
                .bold()
                .padding()
                .background(Color.red)
                .clipShape(Circle())
                .padding()
        }
    }
}

struct HomeView: View {
    
    @State var showPicker: Bool = false
    @State var videoURL = URL(string: "https://www.google.com")!
    
    @StateObject var viewModel = DanceVisionVM()
    
    var WAPIndicator: some View {
        VStack(alignment: .center, spacing: 10) {
            PredictionIndicator(title: "WAP", value: $viewModel.wapVal)
            PredictionIndicator(title: "Other", value: $viewModel.otherVal)
        }
    }

    var videoPickerButton: some View {
        Button(action: {
            self.showPicker = true
        }, label: {
            HStack {
                Spacer()
                Text("Video Picker")
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()

        })
    }

    var performPredictionButton: some View {
        Button(action: {
            viewModel.isWAP()
        }, label: {
            HStack {
                Spacer()
                Text("Perform Prediction")
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()

        })
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    VideoPlayer(videoURL: self.videoURL)
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .id(videoURL.absoluteString)
                    WAPIndicator
                }

                videoPickerButton
                performPredictionButton
            }
            .navigationTitle("Dance Vision")
        }
        .background(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showPicker, content: {
            VideoPicker(showVideoPicker: $showPicker, videoURL: $videoURL, viewModel: viewModel)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
