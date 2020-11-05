//
//  HomeView.swift
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
        HStack(alignment: .center, spacing: 0) {
            VideoPlayer(videoURL: predictedItem.videoURL)
                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            WAPIndicator
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(radius: 10)
        .animation(.default)
    }
}

struct HomeView: View {
    @State var showPicker: Bool = false
    @State var videoURL = URL(string: "https://www.google.com")!
    
    @StateObject var viewModel = DanceVisionVM()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    PredictedItemView(predictedItem: item)
                }
            }
            .navigationTitle("Dance Vision")
            .navigationBarItems(trailing: Button(action: {
                self.showPicker = true
            }, label: {
                Image(systemName: "plus")
            }))
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
