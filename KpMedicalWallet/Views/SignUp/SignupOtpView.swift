//
//  SignupOtpView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import SwiftUI

struct SignupOtpView: View {
    @EnvironmentObject var viewModel: IdControl
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    var body: some View {
        VStack {
            Button {
                print(viewModel.password)
            } label: {
                Text("viewModelTest")
            }
            Button {
                viewModel.goBackLoginView()
            } label: {
                Text("Next")
            }
        }
        .navigationTitle("인증번호")
    }
}

#Preview {
    SignupOtpView()
}
