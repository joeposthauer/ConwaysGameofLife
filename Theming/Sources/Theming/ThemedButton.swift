//
//  ThemedButton.swift
//  SwiftUIGameOfLife
//

import SwiftUI

public struct ThemedButton: View {
    public var text: String
    public var action: () -> Void

    public init(
        text: String,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.action = action
    }

    public var body: some View {
        HStack {

            Button(action: action) {
                Text(text)
                    .font(.system(.body, design: .rounded))
                    //.fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 75.0, height: 75.0)
            }
            .background(Color("accent"))
            // Your Problem 2 code goes here.
            .overlay(Circle().stroke(Color.white, lineWidth: 2.0))
            .frame(width: 75.0, height: 75.0)
            .shadow(radius: 75.0)
            .clipShape(Circle())
        }
    }
}

// MARK: Previews
struct ThemedButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemedButton(text: "Step") { }
    }
}
