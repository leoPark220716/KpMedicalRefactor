//
//  SignupDobView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import SwiftUI

struct SignupDobView: View {
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
                viewModel.movePhonView()
            } label: {
                Text("Next")
            }
        }
        .navigationTitle("생년월일")
    }
}

#Preview {
    SignupDobView()
}
