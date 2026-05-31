//
//  ContentView.swift
//  Claude CarPlay
//
//  Created by Justin Zhao on 5/31/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            VStack {

            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsForm()
            }
        }
    }
}

#Preview {
    ContentView()
}
