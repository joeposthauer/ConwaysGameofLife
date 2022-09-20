//
//  StatisticsView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Theming

public struct StatisticsView: View {
    let store: Store<StatisticsState, StatisticsState.Action>
    let viewStore: ViewStore<StatisticsState, StatisticsState.Action>

    public init(store: Store<StatisticsState, StatisticsState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        NavigationView {
            ZStack{
                Color("BackgroundColor2").ignoresSafeArea()
                VStack {
                    Form {
                        // Your Problem 7A code starts here
                        FormLine(
                            title: "Steps",
                            value: viewStore.statistics.steps
                        )
                        FormLine(
                            title: "Alive",
                            value: viewStore.statistics.alive
                        )
                        FormLine(
                            title: "Born",
                            value: viewStore.statistics.born
                        )
                        FormLine(
                            title: "Died",
                            value: viewStore.statistics.died
                        )
                        FormLine(
                            title: "Empty",
                            value: viewStore.statistics.empty
                        )
                        HStack{
                            Spacer()
                            ThemedButton(text: "Reset") {
                                self.viewStore.send(.reset)
                            }
                            
                            .frame(alignment: .center)
                            
                            Spacer()
                        }
                        
                        
                    }
                    .padding()
                }
                .navigationBarTitle(Text("Statistics"))
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

public struct StatisticsView_Previews: PreviewProvider {
    static let previewState = StatisticsState()
    public static var previews: some View {
        StatisticsView(
            store: Store(
                initialState: previewState,
                reducer: statisticsReducer,
                environment: StatisticsEnvironment()
            )
        )
    }
}
