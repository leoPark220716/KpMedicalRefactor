//
//  SignUpView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct SignupIdView: View {
    @EnvironmentObject var viewModel: IdControl
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            HStack{
                //                아이디 입력 가이드라인 Text
                Text(PlistManager.shared.string(forKey: "signup_id_field_title"))
                    .padding(.leading)
                Spacer()
            }
            HStack{
                TextField(PlistManager.shared.string(forKey: "login_hint"), text: $viewModel.account)
                    .focused($focus)
                    .modifier(SinupIDFildModifier(check: $viewModel.IdFieldStatus))
                    .padding(viewModel.account != "" ? .leading : .horizontal)
                    .onChange(of: viewModel.account) {
                        viewModel.detechIdFild(text: viewModel.account)
                        viewModel.IdresetStatus(text: viewModel.account)
                        
                    }
                //                    중복 확인 버튼
                if viewModel.account != ""{
                    Button {
                        viewModel.actonCheckButton()
                    } label: {
                        Text(PlistManager.shared.string(forKey: "signup_id_check_button"))
                            .modifier(CheckIDFiledButton(active: $viewModel.IdFieldStatus))
                    }
                    .disabled(!viewModel.IdFieldStatus)
                }
            }
            // 유효성 검사 메시지 가이드라인 Text
            HStack{
                if !viewModel.IdFieldStatus{
                    Text(PlistManager.shared.string(forKey: "singup_id_field_error_formet"))
                        .modifier(SignupErrorMessageText(check:$viewModel.IdFieldStatus))
                        .padding(.leading)
                }
                else if !viewModel.idCheck && viewModel.IdFieldStatus && viewModel.account != ""{
                    Text(PlistManager.shared.string(forKey: "singup_id_field_error_match_didnt_done"))
                        .modifier(SignupErrorMessageText(check:$viewModel.idCheck))
                        .padding(.leading)
                }
                else if viewModel.permissionCheck && viewModel.IdFieldStatus && viewModel.idCheck && viewModel.account != "" {
                    Text(PlistManager.shared.string(forKey: "singup_id_success"))
                        .modifier(SignupErrorMessageText(check:$viewModel.idCheck))
                        .padding(.leading)
                }else if !viewModel.permissionCheck && viewModel.account != ""{
                    Text(PlistManager.shared.string(forKey: "singup_id_field_error_not_match"))
                        .modifier(SignupErrorMessageText(check:$viewModel.permissionCheck))
                        .padding(.leading)
                }
                
                Spacer()
            }
            Spacer()
            // 다음 뷰로 넘어가는 버튼
            Button {
                viewModel.movePasswordView()
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_id_access_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.idCheck))
            }
            .padding([.horizontal, .bottom])
            .disabled(!viewModel.idCheck)
        }
        .padding()
        .onAppear{
            focus = true
        }
        .navigationTitle(PlistManager.shared.string(forKey: "signup_id_navigation_title"))
        .navigationBarTitleDisplayMode(.large)
        
    }
}


struct SignupIdView_Priview: PreviewProvider{
    static var previews: some View {
        @StateObject var errorHandler = GlobalErrorHandler()
        @StateObject var router = NavigationRouter()
        @StateObject var viewModel = IdControl(router: router, errorHandler: errorHandler)
        SignupIdView()
            .environmentObject(viewModel)
    }
}
    

