//
//  ChatView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/24/24.
//

import SwiftUI
import BigInt
struct ChatView: View {
    @EnvironmentObject var appManager: NavigationRouter
//    @StateObject var contractManager: KPHWalletContractManager
    @StateObject var socket: ChatHandler
    let ChatTitle: String
    init(appManager: NavigationRouter,hospitalId: Int, HospitalName: String){
//        _contractManager = StateObject(wrappedValue: KPHWalletContractManager(appManager: appManager))
        ChatTitle = HospitalName
        _socket = StateObject(wrappedValue: ChatHandler(hospitalId: hospitalId, account: appManager.GetUserAccountString().account, token: appManager.jwtToken, fcmToken: appManager.jwtToken, appManager: appManager))
        
    }
    var body: some View {
        VStack{
            ChatItemList(socket: socket,HospitalName: ChatTitle)
            ChatViewInputField(socket: socket)
        }
        .onAppear{
            Task{
                await socket.Connect()
            }
        }
        .normalToastView(toast: $appManager.toast)
        .navigationTitle(ChatTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    ChatView(appManager: appManager,hospitalId: 1,HospitalName:"asdf")
        
}
