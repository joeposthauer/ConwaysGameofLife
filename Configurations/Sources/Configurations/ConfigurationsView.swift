//
//  ConfigurationView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Configuration

public struct ConfigurationsView: View {
    let store: Store<ConfigurationsState, ConfigurationsState.Action>
    let viewStore: ViewStore<ConfigurationsState, ConfigurationsState.Action>

    public init(store: Store<ConfigurationsState, ConfigurationsState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store, removeDuplicates: ==)
    }
    
    public var body: some View {
        // Your problem 3A code starts here.
        NavigationView {
            ZStack{
                Color("BackgroundColor3").ignoresSafeArea()
                VStack {
                    List {
                        ForEachStore(
                            self.store.scope(
                                state: \.configs,
                                action: ConfigurationsState.Action.configuration(id:action:)
                            ),
                            content: ConfigurationView.init(store:)
                        )
                    }
                    

                    Divider()
                        //.padding(8.0)
                        .background(Color("accent"))
                
                    HStack {
                        Spacer()
                        Button(action: {
                            self.viewStore.send(.fetch)
                        }) {
                            Text("Fetch").font(.system(size: 24.0))
                        }
                        .foregroundColor(Color("accent"))
                        .padding([.top, .bottom], 8.0)
                        
                        Spacer()
                        
                        Button(action: {
                            self.viewStore.send(.clear)
                        }) {
                            Text("Clear").font(.system(size: 24.0))
                        }
                        .foregroundColor(Color("accent"))
                        .padding([.top, .bottom], 8.0)
                        
                        Spacer()
                    }
                    .padding(.top, 8.0)
                    .padding(.bottom, 16.0)
                }
                //Spacer()
                // Problem 5a goes here
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isAdding,
                        send: { swtch in .stopAdding(swtch) }
                    ),
                    onDismiss: {
                        
                    },
                    content: {
                        AddConfigurationView(
                            store: self.store.scope(
                                state: \.addConfigState,
                                action:
                                    ConfigurationsState.Action.addConfigAction(action:)
                            )
                        )
                    }
                )
                // Problem 3B begins here
                
                .navigationTitle("Configurations")
                .navigationBarHidden(false)
                // Problem 5b Goes here
                .navigationBarItems(trailing: Button("Add") {
                    viewStore.send(.add)
                }
                )
                // Problem 3A ends here
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
        
}

public struct ConfigurationsView_Previews: PreviewProvider {
    static let previewState = ConfigurationsState()
    public static var previews: some View {
        ConfigurationsView(
            store: Store(
                initialState: previewState,
                reducer: configurationsReducer,
                environment: ConfigurationsEnvironment()
            )
        )
    }
}
