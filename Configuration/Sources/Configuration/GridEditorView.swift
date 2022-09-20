//
//  GridEditorView.swift
//  GameOfLife
//

import Foundation
import SwiftUI
import ComposableArchitecture
import GameOfLife
import Grid
import Theming

let deviceType = UIDevice.current.userInterfaceIdiom

private func shorten(to g: GeometryProxy, by: CGFloat = 0.92) -> CGFloat {
    min(min(g.size.width, g.size.height) * by, g.size.height - 120.0)
}

struct GridEditorView: View {
    var store: Store<ConfigurationState, ConfigurationState.Action>
    @ObservedObject var viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>

    init(store: Store<ConfigurationState, ConfigurationState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    
    var spacerLength: CGFloat {
        switch deviceType {
        case .phone: return 40.0
        case .pad: return 70.0
            default: return 40.0
        }
    }
    
    var spacerLength2: CGFloat {
        switch deviceType {
        case .phone: return 157.5
        case .pad: return 200.0
            default: return 157.5
        }
    }

    var body: some View {
        ZStack{
            Color("BackgroundColor")
            VStack {
                GeometryReader { g in
                    if g.size.width < g.size.height {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            self.iphonevview(for: viewStore, geometry: g)
                        } else {
                            self.ipadvview(for: viewStore, geometry: g)
                        }
                    } else {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            self.iphonehview(for: viewStore, geometry: g)
                        } else {
                            self.ipadhview(for: viewStore, geometry: g)
                        }
                    }
                }
            }
            .navigationBarTitle(self.viewStore.configuration.title)
            .navigationBarHidden(false)
            .frame(alignment: .center)
        }
        .edgesIgnoringSafeArea([.top,.horizontal])
    }
    
    func ipadhview(for viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>,
                   geometry g: GeometryProxy
    ) -> some View {
        VStack{
            Spacer(minLength: spacerLength2)
            HStack{
                Spacer(minLength: 330.0)
                // Problem 4A - your code goes here
                GridView(store: self.store.scope(
                    state: \.gridState,
                    action: ConfigurationState.Action.grid(action:)
                    )
                )
                Spacer()
            }
            HStack{
                self.themedButton
                .frame(alignment: .center)
                //Spacer(minLength: 460.0)
            }
            Spacer()
        }
        
    }
    
    func ipadvview(for viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>,
                   geometry g: GeometryProxy
    ) -> some View {
        VStack{
            Spacer(minLength: spacerLength2)
            HStack{
                Spacer(minLength: spacerLength)
                // Problem 4A - your code goes here
                GridView(store: self.store.scope(
                    state: \.gridState,
                    action: ConfigurationState.Action.grid(action:)
                    )
                )
                Spacer()
            }
            HStack{
                self.themedButton
                .frame(alignment: .center)
                //Spacer(minLength: 342.5)
            }
            Spacer()
        }
    }
    
    func iphonehview(for viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>,
                   geometry g: GeometryProxy
    ) -> some View {
            VStack{
                Spacer()
                HStack{
                    Spacer(minLength: 320.0)
                    // Problem 4A - your code goes here
                    GridView(store: self.store.scope(
                        state: \.gridState,
                        action: ConfigurationState.Action.grid(action:)
                        )
                    )
                    Spacer()
                }
                HStack{
                    self.themedButton
                    .frame(alignment: .center)
                    //Spacer(minLength: 375.0)
                }
                Spacer()
            }
    }
    
    func iphonevview(for viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>,
                   geometry g: GeometryProxy
    ) -> some View {
        VStack{
            Spacer(minLength: spacerLength2)
            HStack{
                Spacer(minLength: spacerLength)
                // Problem 4A - your code goes here
                GridView(store: self.store.scope(
                    state: \.gridState,
                    action: ConfigurationState.Action.grid(action:)
                    )
                )
                Spacer()
            }
            HStack{
                self.themedButton
                .frame(alignment: .center)
                //Spacer(minLength: spacerLength2)
            }
            Spacer()
        }
    }
}

// MARK: Subviews
extension GridEditorView {
    var themedButton: some View {
        WithViewStore(store) { viewStore in
            ThemedButton(text: "Simulate") {
                // Problem 4B - your code goes here
                viewStore.send(.simulate((self.viewStore.gridState.grid)))
            }
        }
    }
}

public struct GridEditorView_Previews: PreviewProvider {
    static let grid = Grid(10, 10, Grid.Initializers.random)
    static let previewState = ConfigurationState(
        configuration: try! .init(title: "Example", contents: grid.contents),
        gridState: GridState(grid: grid),
        index: 0
    )
    public static var previews: some View {
        GeometryReader { g in
            GridEditorView(
                store: Store(
                    initialState: previewState,
                    reducer: configurationReducer,
                    environment: ConfigurationEnvironment()
                )
            )
        }
    }
}


