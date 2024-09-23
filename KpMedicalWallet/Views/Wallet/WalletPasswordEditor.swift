//
//  WalletPasswordEditor.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct WalletPasswordEditor: View {
    @EnvironmentObject var appManager: NavigationRouter
    @EnvironmentObject var walletModel: KPHWallet
    @StateObject var viewModel: PasswordControl
    @FocusState private var focus: Bool
    init(appManager: NavigationRouter){
        _viewModel = StateObject(wrappedValue: PasswordControl(router: appManager))
    }
    var body: some View {
        VStack {
            HStack{
                //                비밀번호 입력 가이드라인 Text
                Text(PlistManager.shared.string(forKey: "signup_password_navigation_title"))
                    .modifier(SignupTitldGuaidLine())
                    .padding(.leading)
                Spacer()
            }
            HStack{
                SecureField(PlistManager.shared.string(forKey: "signup_password_hint"), text: $viewModel.password)
                    .modifier(SinupTextFildModifier(check: $viewModel.PassFieldStatus,focus: _focus))
                    .padding( .horizontal)
                    .onChange(of: viewModel.password) {
                        viewModel.detechPasswordField(text: viewModel.password)
                        viewModel.PasswordResetStatus(text: viewModel.password)
                    }
            }
            HStack{
                if !viewModel.PassFieldStatus{
                    Text(PlistManager.shared.string(forKey: "signup_password_error_formet"))
                        .modifier(SignupErrorMessageText(check:$viewModel.PassFieldStatus))
                        .padding(.leading)
                }
                Spacer()
            }
            if viewModel.PassFieldStatus && viewModel.password != ""{
                HStack{
                    //                비밀번호 입력 가이드라인 Text
                    Text(PlistManager.shared.string(forKey: "signup_password_navigation_title2"))
                        .modifier(SignupTitldGuaidLine())
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    SecureField(PlistManager.shared.string(forKey: "signup_password_hint2"), text: $viewModel.passwordSecond)
                        .modifier(SinupTextFildModifier(check: $viewModel.SecondPassFieldStatus))
                        .padding( .horizontal)
                        .onChange(of: viewModel.passwordSecond) {
                            viewModel.detechPasswordFieldSecond(text: viewModel.passwordSecond)
                            viewModel.PasswordResetStatusSecond(text: viewModel.passwordSecond)
                        }
                }
                HStack{
                    if !viewModel.SecondPassFieldStatus && viewModel.passwordSecond != ""{
                        Text(PlistManager.shared.string(forKey: "signup_password_error_not_match"))
                            .modifier(SignupErrorMessageText(check:$viewModel.SecondPassFieldStatus))
                            .padding(.leading)
                    }
                    Spacer()
                }
            }
            Spacer()
            Button {
                walletModel.password = viewModel.password
                walletModel.goToCreateMnemonicView(appManager: appManager)
                
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_password_access_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.PasswordPermission))
            }
            .padding([.horizontal, .bottom])
            .disabled(!viewModel.PasswordPermission)
        }
        .onAppear{
            focus = true
        }
        .navigationTitle("지갑 비밀번호")
    }
}

#Preview {
    @Previewable @StateObject var walletModel = KPHWallet()
    @Previewable @StateObject var appManager = NavigationRouter()
    WalletPasswordEditor(appManager: appManager)
        .environmentObject(walletModel)
}
