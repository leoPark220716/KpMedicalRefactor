//
//  ImageProgressView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ImageProgressView: View {
    var body: some View {
        HStack(alignment: .bottom,spacing: 3){
            Spacer()
            HStack{
                ProgressView()
            }.frame(width: 200, height: 200)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(20)
        }
        .padding(.trailing,3)
        .padding(.leading,20)
    }
}

#Preview {
    ImageProgressView()
}
