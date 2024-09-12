//
//  SignUpMobileView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import SwiftUI

struct SignUpMobileView: View {
    @EnvironmentObject var viewModel: IdControl
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        VStack {
            Button {
                print(viewModel.$password)
            } label: {
                Text("viewModelTest")
            }
            Button {
                viewModel.moveOtpView()
            } label: {
                Text("Next")
            }
        }
        .navigationTitle("휴대폰번호 등록")
    }
}

#Preview {
    SignUpMobileView()
}
