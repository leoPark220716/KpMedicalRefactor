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
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            HStack{
                //                아이디 입력 가이드라인 Text
                Text(PlistManager.shared.string(forKey: "signup_password_navigation_title"))
                    .padding(.leading)
                Spacer()
            }
            HStack{
                SecureField(PlistManager.shared.string(forKey: "signup_password_hint"), text: $viewModel.password)
                    .focused($focus)
                    .modifier(SinupPASSWORDFildModifier(check: $viewModel.PassFieldStatus))
                    .padding( .horizontal)
                    .onChange(of: viewModel.password) {
                        viewModel.detechPasswordField(text: viewModel.password)
                        viewModel.PasswordResetStatus(text: viewModel.password)
                    }
            }
            if viewModel.PassFieldStatus && viewModel.password != ""{
                HStack{
                    //                아이디 입력 가이드라인 Text
                    Text(PlistManager.shared.string(forKey: "signup_password_navigation_title2"))
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    SecureField(PlistManager.shared.string(forKey: "signup_password_hint2"), text: $viewModel.passwordSecond)
                        .focused($focus)
                        .modifier(SinupPASSWORDFildModifier(check: $viewModel.SecondPassFieldStatus))
                        .padding( .horizontal)
                        .onChange(of: viewModel.passwordSecond) {
                            viewModel.detechPasswordFieldSecond(text: viewModel.passwordSecond)
                            viewModel.PasswordResetStatusSecond(text: viewModel.passwordSecond)
                        }
                }
            }
            Spacer()
            Button {
                viewModel.moveDobView()
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_password_access_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.PasswordPermission))
            }
            .padding([.horizontal, .bottom])
            .disabled(!viewModel.PasswordPermission)
        }
        .navigationTitle("비밀번호")
    }
}


struct SignupPasswordView_Priview: PreviewProvider{
    static var previews: some View {
        @StateObject var errorHandler = GlobalErrorHandler()
        @StateObject var router = NavigationRouter()
        @StateObject var viewModel = IdControl(router: router, errorHandler: errorHandler)
        SignupPasswordView()
            .environmentObject(viewModel)
    }
}

