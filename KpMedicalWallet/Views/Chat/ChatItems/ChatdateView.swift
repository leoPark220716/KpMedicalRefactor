//
//  Untitled.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//
import SwiftUI

struct ChatdateView: View {
    var time: String
    var body: some View {
        Text(time)
            .foregroundStyle(Color.white)
            .font(.system(size: 13))
            .padding(10)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10)
            .padding()
    }
}
