//
//  SimulationView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Grid
 
 
@available(iOS 15.0, *)
@available(iOS 15.0, *)
@available(iOS 15.0, *)
struct Ani: AnimatableModifier {
    var g: GeometryProxy
    var fractionComplete: Double = 0.0
    var numberOf3dRotations = 1
    let store: Store<SimulationState,SimulationState.Action>
 
    var animatableData: Double {
        get { fractionComplete }
        set { fractionComplete = newValue }
    }
 
    func body(content: Content) -> some View {
        WithViewStore(store) { viewStore in
            ZStack{
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    GeometryReader { g in
                        if g.size.width < g.size.height {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                self.iphoneverticalContent(for: viewStore, geometry: g)
                            } else {
                                self.ipadvContent(for: viewStore, geometry: g)
                            }
                        } else {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                self.iphonehorizontalContent(for: viewStore, geometry: g)
                            } else {
                                self.ipadhContent(for: viewStore, geometry: g)
                            }
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("Simulation")
                .navigationBarHidden(false)
                // Problem 6 - your answer goes here.
                .onAppear {
                    viewStore.shouldRestartTimer ? viewStore.send(.startTimer) : viewStore.send(.stopTimer)
                }
                .onDisappear {
                    viewStore.send(.setShouldRestartTimer(viewStore.isRunningTimer))
                    viewStore.send(.stopTimer)
                }
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
        }
    }
    
    func iphoneverticalContent(
        for viewStore: ViewStore<SimulationState, SimulationState.Action>,
        geometry g: GeometryProxy
    ) -> some View {
        VStack {
            Spacer(minLength: 150.0)
            //Spacer()
            //Spacer()
            InstrumentationView(
                store: self.store,
                width: g.size.width * 0.82
            )
            .frame(height: g.size.height * 0.35)
            .padding(.bottom, 16.0)
 
            Divider()
                .background(Color("accent"))
 
            HStack{
                Spacer(minLength: 50.0)
                GridView(
                    store: self.store.scope(
                        state: \.gridState,
                        action: SimulationState.Action.grid(action:)
                    )
                )
                    .rotationEffect(
                        Angle(radians: Double.pi * 2.0*(Double(Int.random(in:-1..<2))))
                    )
                //Spacer(minLength: 50.0)
            }
            
            //Spacer()
        }
    }
 
    func iphonehorizontalContent(
        for viewStore: ViewStore<SimulationState, SimulationState.Action>,
        geometry g: GeometryProxy
    ) -> some View {
        HStack {
            Spacer()
            InstrumentationView(store: self.store)
            Spacer()
            Divider()
                .background(Color("accent"))
            Spacer(minLength: 50.0)
            VStack{
                Spacer(minLength: 30.0)
                GridView(
                    store: self.store.scope(
                        state: \.gridState,
                        action: SimulationState.Action.grid(action:)
                    )
                )
                    .rotationEffect(
                        Angle(radians: Double.pi * 2.0*(Double(Int.random(in:-1..<2))))
                    )
                .frame(width: g.size.height)
            }
            
            Spacer()
        }
    }
    
    func ipadhContent(for viewStore: ViewStore<SimulationState, SimulationState.Action>,
                     geometry g: GeometryProxy
    ) -> some View {
        HStack {
            Spacer()
            InstrumentationView(store: self.store)
            Spacer()
            Divider()
                .background(Color("accent"))
            Spacer(minLength: 50.0)
            VStack{
                Spacer(minLength: 50.0)
                GridView(
                    store: self.store.scope(
                        state: \.gridState,
                        action: SimulationState.Action.grid(action:)
                    )
                )
                    .rotationEffect(
                        Angle(radians: Double.pi * 2.0*(Double(Int.random(in:-1..<2))))
                    )
                .frame(width: g.size.height)
            }
            
            Spacer()
        }
    }
    
    func ipadvContent(for viewStore: ViewStore<SimulationState, SimulationState.Action>,
    geometry g: GeometryProxy) -> some View {
        VStack {
            Spacer(minLength: 70.0)
            InstrumentationView(
                store: self.store,
                width: g.size.width * 0.82
            )
            .frame(height: g.size.height * 0.35)
            .padding(.bottom, 16.0)
 
            Divider()
                .background(Color("accent"))
            Spacer(minLength: 50.0)
            HStack{
                Spacer(minLength: g.size.width/5.0)
                GridView(
                    store: self.store.scope(
                        state: \.gridState,
                        action: SimulationState.Action.grid(action:)
                    )
                )
                    .rotationEffect(
                        Angle(radians: Double.pi * 2.0*(Double(Int.random(in:-1..<2))))
                    )
                //Spacer(minLength: 10.0)
            }
            
            //Spacer()
        }
    }
}
 

 
@available(iOS 15.0, *)
@available(iOS 15.0, *)
@available(iOS 15.0, *)
public struct SimulationView: View {
    let store: Store<SimulationState, SimulationState.Action>
 
    public init(store: Store<SimulationState, SimulationState.Action>) {
        self.store = store
    }
 
    public var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                GeometryReader { outer in
                    EmptyView()
                        .modifier(
                            Ani(
                                g: outer,
                                fractionComplete: viewStore.start ? 0.0 : 1.0,
                                numberOf3dRotations: Int.random(in: -4 ... 4),
                                store: self.store
                            )
                        )
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
 
    
}
 
@available(iOS 15.0, *)
@available(iOS 15.0, *)
public struct SimulationView_Previews: PreviewProvider {
    static let previewState = SimulationState()
    public static var previews: some View {
        Group {
            SimulationView(
                store: Store(
                    initialState: previewState,
                    reducer: simulationReducer,
                    environment: SimulationEnvironment()
                )
            )
                .previewInterfaceOrientation(.portrait)
            SimulationView(
                store: Store(
                    initialState: previewState,
                    reducer: simulationReducer,
                    environment: SimulationEnvironment()
                )
            )
.previewInterfaceOrientation(.landscapeRight)
        }
    }
}
