//
//  SwiftUIView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import SwiftUI

struct SignupPasswordView: View {
    @EnvironmentObject var viewModel: IdControl
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    var body: some View {
        VStack {
            Button {
                print(viewModel.$password)
            } label: {
                Text("viewModelTest")
            }
            Button {
                viewModel.moveDobView()
            } label: {
                Text("Next")
            }
        }
        .navigationTitle("비밀번호")
    }
}

#Preview {
    SignupPasswordView()
}
