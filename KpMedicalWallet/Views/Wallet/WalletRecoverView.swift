//
//  WalletRecoverView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/24/24.
//

import SwiftUI
import Combine

struct WalletRecoverView: View {
    @EnvironmentObject var walletModel: KPHWallet
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel: PasswordControl
    @FocusState var focus: Bool
    @State var tab: Bool = false
    @State private var showAlert = false
    @State var isLoading = false
    init(appManager: NavigationRouter){
        _viewModel = StateObject(wrappedValue: PasswordControl(router: appManager))
    }
    var body: some View {
        GeometryReader{ geo in
            if !isLoading{
                VStack{
                    HStack{
                        Text("니모닉 문구 작성란")
                            .bold()
                            .font(.title3)
                            .padding(.leading,20)
                        Spacer()
                    }
                    ZStack{
                        TextEditor(text: $walletModel.Mnemonicse)
                            .frame(height: geo.size.height * 0.2)
                            .font(.custom("Helvetica Nenu", size: 15))
                            .background(Color.white) // 배경 색 설정
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .focused($focus)
                            .onChange(of: focus) {
                                if focus == true{
                                    tab = true
                                }
                            }
                        Spacer()
                        if !tab{
                            Text("찾고자 하는 지갑의 니모닉 문구를 작성해주세요.")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom)
                    passwordStructFrom(viewModel: viewModel,focus: _focus)
                    Spacer()
                    Button{
                        showAlert = true
                    }label: {
                        Text("지갑복구")
                            .modifier(ActiveUnActiveButton(active: $viewModel.PasswordPermission))
                    }
                    .padding([.horizontal, .bottom])
                    .disabled(!viewModel.PasswordPermission)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("지갑 복구"),
                        message: Text("해당 정보로 지갑을 복구하시겠습니까?."),
                        primaryButton: .destructive(Text("확인")) {
                            isLoading = true
                            walletModel.TrasactionList = []
                            walletModel.OnTabRecoverWalletButton(appManager: appManager, password: viewModel.password)
                        },
                        secondaryButton: .cancel()
                    )
                }
                .navigationTitle("지갑 복구")
            }else{
                HStack{
                    Spacer()
                    SomeThingLoadingWithText(text: "지갑을 복구하고 있습니다.")
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var walletModel = KPHWallet()
    @Previewable @StateObject var appManager = NavigationRouter()
    WalletRecoverView(appManager: appManager)
        .environmentObject(walletModel)
}

struct passwordStructFrom: View {
    @ObservedObject var viewModel: PasswordControl
    @FocusState var focus: Bool
    var body: some View {
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
    }
}
