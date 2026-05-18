//
//  ContentView.swift
//  TCAAndMiniReduxLists
//
//  Created by Bao Lei on 5/18/26.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      MiniReduxListView()
        .tabItem {
          Label("MiniRedux", systemImage: "list.bullet.rectangle")
        }

      TCAListView(
        store: Store(initialState: TCAListFeature.State()) {
          TCAListFeature()
        }
      )
      .tabItem {
        Label("TCA", systemImage: "list.bullet.indent")
      }
    }
  }
}

#Preview {
  ContentView()
}
