//
//  AppOtpView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct AppOtpView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel: OtpViewModel
    
    let viewCase: OtpViewModel.routeType
    @Environment(\.dismiss) var dismiss
    init(viewCase: OtpViewModel.routeType, socket: ChatHandler? = nil){
        self.viewCase = viewCase
        _viewModel = StateObject(wrappedValue: OtpViewModel(socket: socket, viewCase: viewCase))
    }
    var body: some View {
        GeometryReader { geo in
            VStack{
                if viewModel.otpStatus == false{
                    HStack{
                        Button{
                            viewModel.createOtpReset()
                        } label: {
                            Text("재설정")
                                .foregroundStyle(Color.blue)
                                .bold()
                                .padding()
                        }
                        Spacer()
                    }
                }
                Spacer()
                Text(viewModel.guaidLineString)
                    .bold()
                    .font(.title3)
                HStack{
                    ForEach(0..<6, id: \.self){ index in
                        Circle()
                            .stroke(Color.blue.opacity(0.8), lineWidth: 1)
                            .frame(width:20,height: 20)
                            .overlay(
                                Circle().fill(viewModel.password.count > index ? Color.blue : Color.blue.opacity(0.2))
                            )
                            .padding(.horizontal,4)
                    }
                }
                .padding()
                if !viewModel.matchCheck{
                    Text("인증번호가 일치하지 않습니다.")
                        .foregroundStyle(Color.red)
                }
                Spacer()
                PasswordNumberPad(viewModel: viewModel,geo: geo)
            }
            .onChange(of: viewModel.Dismiss){
                if viewModel.Dismiss == true{
                    dismiss()
                }
            }.onChange(of: viewModel.password){
                if viewModel.password != ""{
                    viewModel.matchCheck = true
                }
            }
            .onAppear{
                viewModel.setOtpStatus(appManager: appManager)
            }
        }
    }
}

struct PasswordNumberPad: View {
    @ObservedObject var viewModel: OtpViewModel
    let geo: GeometryProxy
    var body: some View {
        VStack(spacing: 0){
            ForEach(viewModel.rows, id:\.self) { row in
                HStack(spacing:0){
                    ForEach(row, id: \.self){item in
                        Button{
                            viewModel.ButtonAction(item)
                        }label: {
                            Text(item)
                                .bold()
                                .font(.system(size: geo.size.height * 0.028))
                                .frame(height: geo.size.height * 0.09)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                        }
                    }
                }

            }
        }
        .onAppear{
            viewModel.reArrangeNumbers()
        }
    }
    
    
}

#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    AppOtpView(viewCase: OtpViewModel.routeType.walletView)
        .environmentObject(appManager)
}
