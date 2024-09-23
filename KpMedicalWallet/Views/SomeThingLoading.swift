//
//  SomeThingLoading.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import SwiftUI

struct SomeThingLoading: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
}

#Preview {
    SomeThingLoading()
}
