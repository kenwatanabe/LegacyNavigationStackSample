//
//  ContentView.swift
//  LegacyNavigationStackSample
//
//  Created by kenjiwatanabe on 2025/02/14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router()
    @StateObject private var sharedFormViewModel = SharedFormViewModel()
    
    var body: some View {
        NavigationContainer()
            .environmentObject(router)
            .environmentObject(sharedFormViewModel)
    }
}

#Preview {
    ContentView()
}
