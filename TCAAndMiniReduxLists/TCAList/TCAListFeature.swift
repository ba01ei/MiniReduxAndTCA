//
//  TCAListFeature.swift
//  TCAAndMiniReduxLists
//

import ComposableArchitecture
import Foundation

@Reducer
struct TCAItemFeature {
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: Int
    var number: Int
  }

  enum Action {
    case cellTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cellTapped:
        state.number += 1
        return .none
      }
    }
  }
}

@Reducer
struct TCAListFeature {
  @ObservableState
  struct State: Equatable {
    var items: IdentifiedArrayOf<TCAItemFeature.State> = []
    var lastTappedID: Int?
  }

  enum Action {
    case onAppear
    case items(IdentifiedActionOf<TCAItemFeature>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard state.items.isEmpty else { return .none }
        state.items = IdentifiedArrayOf(
          uniqueElements: (1...1000).map { TCAItemFeature.State(id: $0, number: $0) }
        )
        return .none

      case let .items(.element(id: id, action: .cellTapped)):
        state.lastTappedID = id
        return .none

      case .items:
        return .none
      }
    }
    .forEach(\.items, action: \.items) {
      TCAItemFeature()
    }
  }
}
