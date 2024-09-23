//
//  SomeThingLoadingWithText.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct SomeThingLoadingWithText: View {
    let text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0, anchor: .center) // Makes the spinner larger
            
            Spacer()
        }
    }
}

#Preview {
    SomeThingLoadingWithText(text: "asdfsd")
}
