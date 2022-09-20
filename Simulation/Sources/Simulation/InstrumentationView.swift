//
//  InstrumentationView.swift
//  SwiftUIGameOfLife
//

import SwiftUI
import ComposableArchitecture
import Theming

fileprivate let formatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 3
    return nf
}()

let deviceType = UIDevice.current.userInterfaceIdiom

@available(iOS 15.0, *)
struct InstrumentationView: View {
    let store: Store<SimulationState, SimulationState.Action>
    private var width: CGFloat
    
    var slength: Double {
        switch deviceType {
        case .phone: return 25.0
        case .pad:
            if UIDevice.current.orientation.isLandscape {
                return 10.0
            } else {
                return 100.0
            }
        default: return 25.0
        }
    }
    

    init(
        store: Store<SimulationState, SimulationState.Action>,
        width: CGFloat = 300.0
    ) {
        self.store = store
        self.width = width
    }

    var body: some View {
        VStack {
            control1(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control2(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control3(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control4(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            buttons
                .frame(width: width, alignment: .center)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.top, 16.0)
        }
    }

    func control1(_ width: CGFloat) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("Size: \(Int(viewStore.gridState.grid.size.rows))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.65, alignment: .bottomLeading)
                    .padding(0.0)
                Spacer()
                Text("Depth")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.25, alignment: .bottomTrailing)
                    .padding(0.0)
            }
        }
    }

    func control2(_ width: CGFloat) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Slider(
                    value: viewStore.binding(
                        get: { Double($0.gridState.grid.size.rows) },
                        send: { .setGridSize(Int($0)) }
                    ),
                    in: 5 ... 40,
                    step: 1,
                    onEditingChanged: { (changed) in },
                    minimumValueLabel: Text("5").font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    maximumValueLabel: Text("40").font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    label: { Spacer() }
                )
                .frame(width: width * 0.65, alignment: .bottomLeading)
                .accentColor(Color("accent"))


                Spacer()

                Text(self.cycleLength(for: viewStore))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.25, alignment: .trailing)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        Color("textBackground")
                            .frame(width: width * 0.25, height: 31.0, alignment: .leading)
                            .fixedSize(horizontal: true, vertical: true)
                    )
            }
        }
    }

    func control3(_ width: CGFloat) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("Refresh Period: \(self.numberString(for: viewStore.timerInterval))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.55, alignment: .bottomLeading)
                    .offset(x: 0.0)
                    .padding(0.0)

                Spacer()

                Text("Simulation")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .frame(width: width * 0.45, alignment: .bottomTrailing)
                    .padding(0.0)
                    .foregroundColor(viewStore.isRunningTimer ? .blue : Color("accent"))
            }
        }
    }

    func control4(_ width: CGFloat) -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Slider(
                    value: viewStore.binding(
                        get: \.timerInterval,
                        send: { .setTimerInterval($0) }
                    ),
                    in: 0.0 ... 1.0,
                    step: 0.1,
                    onEditingChanged: { (changed) in },
                    minimumValueLabel: Text("0.0")
                        .font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    maximumValueLabel: Text("1.0")
                        .font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    label: { Spacer() }
                )
                .frame(width: width * 0.65, alignment: .bottomLeading)
                .accentColor(Color("accent"))

                Spacer()

                Toggle(isOn:
                    viewStore.binding(
                        get: \.isRunningTimer,
                        send: { .toggleTimer($0) }
                    )
                ) {
                    EmptyView()
                }
                .tint(Color("accent"))
                .frame(width: width * 0.25, alignment: .bottomTrailing)
            }
        }
    }

    var buttons: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Spacer()
                ThemedButton(text: "Step") {
                    
                    DispatchQueue.main.async {
                        viewStore.send(.animate)
                    }
                    viewStore.send(.stepGrid)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewStore.send(
                            .stopanimate,
                            animation: .easeOut(duration: 2.0)
                        )
                    }
                }
                Spacer()
                ThemedButton(text: "Empty") { viewStore.send(.resetGridToEmpty) }
                Spacer()
                ThemedButton(text: "Random") { viewStore.send(.resetGridToRandom) }
                Spacer()
            }
        }
    }

    func cycleLength(for viewStore: ViewStore<SimulationState, SimulationState.Action>) -> String {
        guard let cycleLength = viewStore.gridState.history.cycleLength else { return "" }
        return "\(cycleLength)"
    }

    func numberString(for value: Double) -> String {
        "\(formatter.string(from: NSNumber(value: value) ) ?? "")"
    }
}

@available(iOS 15.0, *)
@available(iOS 15.0, *)
struct InstrumentationView_Previews: PreviewProvider {
    static let previewState = SimulationState()
    public static var previews: some View {
        Group {
            InstrumentationView(
                store: Store(
                    initialState: previewState,
                    reducer: simulationReducer,
                    environment: SimulationEnvironment()
                )
            )
            InstrumentationView(
                store: Store(
                    initialState: previewState,
                    reducer: simulationReducer,
                    environment: SimulationEnvironment()
                )
            )
        }
    }
}
