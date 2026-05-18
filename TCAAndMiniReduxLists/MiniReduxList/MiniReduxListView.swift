//
//  MiniReduxListView.swift
//  TCAAndMiniReduxLists
//

import MiniRedux
import SwiftUI

struct MiniReduxListView: View {
  @State private var store = MiniReduxListStore()

  var body: some View {
    NavigationStack {
      List(store.items) { itemStore in
        MiniReduxItemRow(store: itemStore)
      }
      .listStyle(.plain)
      .navigationTitle("MiniRedux")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if let id = store.lastTappedID {
            Text("Last: \(id)")
              .font(.footnote)
              .foregroundStyle(.secondary)
          }
        }
      }
    }
    .onAppear { store.send(.onAppear) }
  }
}

struct MiniReduxItemRow: View {
  let store: MiniReduxItemStore

  var body: some View {
    Button {
      store.send(.cellTapped)
    } label: {
      HStack {
        Text("Item \(store.id)")
        Spacer()
        Text("\(store.number)")
          .monospacedDigit()
          .foregroundStyle(.secondary)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  MiniReduxListView()
}
