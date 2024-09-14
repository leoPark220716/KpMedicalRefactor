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
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            HStack{
                //                휴대폰 번호 입력 가이드라인 Text
                Text(PlistManager.shared.string(forKey: "signup_mobile_guaidline"))
                    .modifier(SignupTitldGuaidLine())
                    .padding(.leading)
                Spacer()
            }
            TextField(PlistManager.shared.string(forKey: "signup_mobile_hint"), text: $viewModel.phone)
                .keyboardType(.numberPad)
                .modifier(SinupTextFildModifier(check: $viewModel.numberCheck,focus: _focus))
                .padding(.horizontal)
                .onChange(of: viewModel.phone) {
                    viewModel.LinmitPhoneNumber()
                    viewModel.MobileNumberCheck()
                    
                }
            Spacer()
            Button {
                viewModel.SignUpOtpActonCheckButton()
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_mobile_access_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.NumberPermissionCheck))
            }
            .disabled(!viewModel.NumberPermissionCheck)
            .padding([.horizontal, .bottom])
            .sheet(isPresented: $viewModel.otpViewShow, content: {
                SignupOtpView(viewModel: .constant(viewModel), errorHandler: .constant(errorHandler))
                    .presentationDetents([.fraction(0.5)])
            })
        }
        .modifier(ErrorAlertModifier(errorHandler: errorHandler))
        .onAppear{
            focus = true
        }
        .navigationTitle("휴대폰번호 등록")
    }
}

struct SignUpMobileView_Priview: PreviewProvider{
    static var previews: some View {
        @StateObject var errorHandler = GlobalErrorHandler()
        @StateObject var router = NavigationRouter()
        @StateObject var viewModel = IdControl(router: router, errorHandler: errorHandler)
        SignUpMobileView()
            .environmentObject(viewModel)
    }
}
