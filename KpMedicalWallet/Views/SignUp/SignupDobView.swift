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
    @State private var showDataPicker = false
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            HStack{
                //                이름 타이틀 가이드라인
                Text(PlistManager.shared.string(forKey: "signup_dob_name_guaidline"))
                    .modifier(SignupTitldGuaidLine())
                    .padding(.leading)
                Spacer()
            }
            //            이릅입력
            TextField(PlistManager.shared.string(forKey: "signup_dob_name_hint"),text: $viewModel.name)
                .modifier(SinupTextFildModifier(check: $viewModel.nameCheck,focus: _focus))
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: viewModel.name) {
                    viewModel.DobPermissionCheck()
                }
            HStack{
                //                이름 타이틀 가이드라인
                Text(PlistManager.shared.string(forKey: "signup_dob_dob_guaidline"))
                    .modifier(SignupTitldGuaidLine())
                    .padding(.leading)
                Spacer()
            }
            //                생년월일 피커 액티브
            Button{
                showDataPicker = true
                focus = false
            } label: {
                HStack{
                    TextField(PlistManager.shared.string(forKey: "signup_dob_dob_hint"), text: $viewModel.viewBirthDate)
                        .modifier(SignupDobFieldModifier())
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.bottom)
            .onChange(of: viewModel.birthDate){
                viewModel.dobSetting()
                viewModel.DobPermissionCheck()
            }
            .sheet(isPresented: $showDataPicker, content: {
                DatePickerDialogView(birthDate: $viewModel.birthDate)
                    .presentationDetents([.fraction(0.5)])
            })
            if viewModel.name != "" && viewModel.viewBirthDate != ""{
                HStack{
                    //                성별 타이틀 가이드라인
                    Text(PlistManager.shared.string(forKey: "signup_dob_ssx_guaidline"))
                        .modifier(SignupTitldGuaidLine())
                        .padding(.leading)
                    Spacer()
                }
                HStack(spacing: 20) {
                    Button{
                        viewModel.selectedGender = .male
                    } label: {
                        Text(PlistManager.shared.string(forKey: "signup_dob_sex_1"))
                            .modifier(SginupGenderButtonModifier(gender: $viewModel.selectedGender, male: true))
                    }
                    .padding(.leading)
                    Button{
                        viewModel.selectedGender = .female
                    } label: {
                        Text(PlistManager.shared.string(forKey: "signup_dob_sex_2"))
                            .modifier(SginupGenderButtonModifier(gender: $viewModel.selectedGender, male: false))
                    }
                    Spacer()
                }
                .onChange(of: viewModel.selectedGender) {
                    viewModel.sexcodeSet()
                    viewModel.DobPermissionCheck()
                }
            }
            Spacer()
            Button {
                viewModel.movePhonView()
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_dob_access_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.DobSexPermission))
            }
            .padding([.horizontal, .bottom])
            .disabled(!viewModel.DobSexPermission)
        }
        .modifier(ErrorAlertModifier(errorHandler: errorHandler))
        .onAppear{
            focus = true
        }
        .navigationTitle("생년월일")
    }
}


struct SignupDobView_Priview: PreviewProvider{
    static var previews: some View {
        @StateObject var errorHandler = GlobalErrorHandler()
        @StateObject var router = NavigationRouter()
        @StateObject var viewModel = IdControl(router: router, errorHandler: errorHandler)
        SignupDobView()
            .environmentObject(viewModel)
    }
}


