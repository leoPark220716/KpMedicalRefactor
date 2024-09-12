//
//  AgreementView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import SwiftUI

struct AgreementView: View {
    @StateObject private var viewModel: AgreementViewModel
    init(appManager: NavigationRouter) {
        _viewModel = StateObject(wrappedValue: AgreementViewModel(appManager: appManager))
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Toggle(PlistManager.shared.string(forKey: "agree_all_service"), isOn: Binding(
                get: {viewModel.agreeToAll}, set: { Bool in
                    viewModel.agreeToServiceTerms = Bool
                    viewModel.agreeToPrivacyPolicy = Bool
                    viewModel.agreeToPushNotifications = Bool
                    viewModel.agreeToAll = Bool
                }))
            .toggleStyle(CheckboxToggleStyle(isTitle: true))
            .foregroundStyle(.blue)
            .padding(.top)
            .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
            Divider()
            HStack{
                Toggle(PlistManager.shared.string(forKey: "agree_terms"), isOn: $viewModel.agreeToServiceTerms)
                    .toggleStyle(CheckboxToggleStyle(isTitle: false))
                    .foregroundStyle(.blue)
                Button(action:{
                    viewModel.openURL(PlistManager.shared.string(forKey: "agree_terms_url"))
                }){
                    Image(systemName: "chevron.right")
                }
            }
            HStack{
                Toggle(PlistManager.shared.string(forKey: "privacy_policy"), isOn: $viewModel.agreeToPrivacyPolicy)
                    .toggleStyle(CheckboxToggleStyle(isTitle: false))
                    .foregroundStyle(.blue)
                
                Button(action:{
                    viewModel.openURL(PlistManager.shared.string(forKey: "privacy_policy_url"))
                } ){
                    Image(systemName: "chevron.right")
                }
            }
            HStack{
                Toggle(PlistManager.shared.string(forKey: "privacy_policy"), isOn: $viewModel.agreeToPushNotifications)
                    .toggleStyle(CheckboxToggleStyle(isTitle: false))
                    .foregroundStyle(.blue)
                Button(action:{
                    viewModel.openURL(PlistManager.shared.string(forKey: "push_notifications_url"))
                }){
                    Image(systemName: "chevron.right")
                }
            }
            Spacer()
            Button(action: {
                viewModel.actionAgreeButton()
            }) {
                Text(PlistManager.shared.string(forKey: "agree_button"))
                    .modifier(ActiveUnActiveButton(active: $viewModel.active))
            }
            .padding(.horizontal)
            .disabled(!viewModel.active)
        }
        .navigationTitle(PlistManager.shared.string(forKey: "agree_nav_title"))
        .padding()
        .onChange(of: viewModel.agreeToServiceTerms){
            viewModel.updateAgreeToAll()
            viewModel.updateButtonState()
        }
        .onChange(of: viewModel.agreeToPrivacyPolicy) {
            viewModel.updateAgreeToAll()
            viewModel.updateButtonState()
        }
        .onChange(of: viewModel.agreeToPushNotifications) { viewModel.updateAgreeToAll()}
    }
    
}
struct AgreementView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        AgreementView(appManager: router)
            .environmentObject(router)
    }
}
