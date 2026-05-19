//
//  TCAListView.swift
//  TCAAndMiniReduxLists
//

import ComposableArchitecture
import SwiftUI

struct TCAListView: View {
  @Bindable var store: StoreOf<TCAListFeature>

  var body: some View {
    NavigationStack {
      List {
        ForEach(
          store.scope(state: \.items, action: \.items)
        ) { itemStore in
          TCAItemRow(store: itemStore)
        }
      }
      .listStyle(.plain)
      .navigationTitle("TCA")
      .toolbar {
        if let id = store.lastTappedID {
          ToolbarItem(placement: .topBarTrailing) {
            Text("Last: \(id)")
              .font(.footnote)
              .foregroundStyle(.secondary)
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Add") {
            store.send(.addTapped)
          }
        }
      }
    }
    .onAppear { store.send(.onAppear) }
  }
}

struct TCAItemRow: View {
  let store: StoreOf<TCAItemFeature>
  
  var body: some View {
    let _ = print("[TCA] row rendered for \(store.id)")
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
  TCAListView(
    store: Store(initialState: TCAListFeature.State()) {
      TCAListFeature()
    }
  )
}
