//
//  SomethingEmpty.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import SwiftUI

struct SomethingEmpty: View {
    let text: String
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
        .padding() // 내부 여백 추가
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2) // 실제 테두리
        )
        .padding() // 외부 여백 추가
    }
}

#Preview {
    SomethingEmpty(text: "dsfsd")
}
