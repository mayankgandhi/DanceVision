//
//  HomeView.swift
//  DanceVision
//
//  Created by Mayank Gandhi on 11/4/20.
//

import SwiftUI

struct HomeView: View {
    
    @State var showPicker: Bool = false
    @State var videoURL = URL(string: "https://www.google.com")!
    @StateObject var viewModel = DanceVisionVM()
    
    var checkNew: Button<Text> {
        Button(action: {
            self.showPicker = true
        }, label: {
            Text("isWAP?")
        })
    }
    
    let columns = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if(viewModel.items.count > 0) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.items, id: \.self) { item in
                            PredictedItemView(predictedItem: item)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack {
                        Spacer()
                        Text("Press the isWAP? button to check whether the selected dance video is WAP or not.")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                }
            }
            .animation(.default)
            .navigationTitle("WAP or Not?")
            .navigationBarItems(trailing: checkNew)
           
        }
        .toast(isShowing: $viewModel.showToast, type: viewModel.toastType)
        .background(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showPicker, content: {
            VideoPicker(showVideoPicker: $showPicker, videoURL: $videoURL, viewModel: viewModel)
                .ignoresSafeArea()
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
