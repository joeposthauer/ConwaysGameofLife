//
//  AddConfigurationView.swift
//  FinalProject
//

import SwiftUI
import ComposableArchitecture
import Combine
import Theming

struct AddConfigurationView: View {
    var store: Store<AddConfigState, AddConfigState.Action>
    @ObservedObject var viewStore: ViewStore<AddConfigState, AddConfigState.Action>
    @State private var keyboardHeight: CGFloat = 0

    init(store: Store<AddConfigState, AddConfigState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    //Problem 5C Goes inside the following HStacks...
                    HStack {
                        Spacer()
                        Text("Title:")
                            .foregroundColor(Color("accent"))
                            .padding(.trailing, 8.0)
                            .frame(width: proxy.size.width * 0.2 , alignment: .trailing)
                        TextField(
                            "0",
                            text: self.viewStore.binding(get: \.title, send: { .updateTitle($0)} ))
                    }
                    HStack {
                        
                        Text("Size:")
                            .foregroundColor(Color("accent"))
                            .padding(.trailing, 8.0)
                            .frame(width: proxy.size.width * 0.2, alignment: .trailing)
                        CounterView(store: self.store.scope(
                            state: \.counterState,
                            action: AddConfigState.Action.counterStateAction(action:))
                                    )
                    }
                    
                }
                .padding()
                Divider()
                    .background(Color("accent"))
                .padding(.bottom, 24.0)

                HStack {
                    Spacer()
                    // Problem 5D - your answer goes in the following buttons
                    ThemedButton(text: "Save") {
                        self.viewStore.send(.ok)
                    }
                    Spacer()
                    ThemedButton(text: "Cancel") {
                        self.viewStore.send(.cancel)
                    }
                    
                    Spacer()
                }
            }
            .font(.title)
            .frame(width: proxy.size.width * 0.75)
        }
    }
}

struct AddConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        AddConfigurationView(
            store: Store<AddConfigState, AddConfigState.Action>(
                initialState: AddConfigState(
                    title: "",
                    counterState: CounterState(count: 10)
                ),
                reducer: addConfigReducer,
                environment: AddConfigEnvironment()
            )
        )
    }
}
