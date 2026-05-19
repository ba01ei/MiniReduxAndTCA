//
//  MiniReduxListStore.swift
//  TCAAndMiniReduxLists
//

import Foundation
import MiniRedux

@MainActor
@Observable
final class MiniReduxItemStore: BaseStore<MiniReduxItemStore.Action>, Identifiable {
  let id: Int
  var number: Int

  init(id: Int, number: Int) {
    self.id = id
    self.number = number
  }

  enum Action: Sendable {
    case cellTapped
  }

  override func reduce(_ action: Action) -> Effect<Action> {
    switch action {
    case .cellTapped:
      number += 1
      return .none
    }
  }
}

@MainActor
@Observable
final class MiniReduxListStore: BaseStore<MiniReduxListStore.Action> {
  var items: [MiniReduxItemStore] = []
  var lastTappedID: Int? = nil

  enum Action: Sendable {
    case onAppear
    case itemAction(id: Int, MiniReduxItemStore.Action)
    case addTapped
  }

  override func reduce(_ action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      items = (0..<100).map { number in
        MiniReduxItemStore(id: number, number: number).delegateAction(to: self, {
          .itemAction(id: number, $0)
        })
      }
      return .none

    case .itemAction(let id, let childAction):
      switch childAction {
      case .cellTapped:
        lastTappedID = id
        return .none
      }
      
    case .addTapped:
      let num = items.count
      items.insert(
        MiniReduxItemStore(id: num, number: num).delegateAction(to: self, {
          .itemAction(id: num, $0)
        }),
        at: 0,
      )
      return .none

    }
  }
}
