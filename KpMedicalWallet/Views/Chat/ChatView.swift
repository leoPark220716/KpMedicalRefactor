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
    @Environment(\.scenePhase) private var scenePhase
//    @StateObject var contractManager: KPHWalletContractManager
    @StateObject var socket: ChatHandler
    @FocusState var chatField: Bool
    let ChatTitle: String
    init(appManager: NavigationRouter,hospitalId: Int, HospitalName: String){
//        _contractManager = StateObject(wrappedValue: KPHWalletContractManager(appManager: appManager))
        ChatTitle = HospitalName
        _socket = StateObject(wrappedValue: ChatHandler(hospitalId: hospitalId, account: appManager.GetUserAccountString().account, token: appManager.jwtToken, fcmToken: appManager.jwtToken, appManager: appManager))
        
    }
    var body: some View {
        VStack{
            ChatItemList(socket: socket,HospitalName: ChatTitle)
                .onTapGesture {
                    chatField = false
                }
            ChatViewInputField(socket: socket,chatField: _chatField)
        }
        .onAppear{
            socket.isActiveOnChatView = true
            Task{
                await socket.Connect()
            }
        }.onDisappear{
            socket.isActiveOnChatView = false
            Task{
                _ = await socket.sendMessage(msg_type: 2, from: socket.account, to: String(socket.hospitalId), content_type: "text")
                socket.disconnect()
            }
        }
        .onChange(of: scenePhase, {
            
        })
        .normalToastView(toast: $appManager.toast)
        .navigationTitle(ChatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: socket.handleBackButton) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
    private func handleScenPhaseChange(_ phase: ScenePhase){
        switch phase {
        case .background:
            socket.isActiveOnChatView = false
            socket.disconnect()
        case .inactive:
            print("App inactive")
        case .active:
            socket.isActiveOnChatView = true
            Task{
                await socket.Connect()
            }
        @unknown default:
            appManager.displayError(ServiceError: .unowned("pahse didntwork"))
        }
    }
}
#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    ChatView(appManager: appManager,hospitalId: 1,HospitalName:"asdf")
        
}
