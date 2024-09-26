//
//  ChatItemList.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ChatItemList: View {
    @ObservedObject var socket: ChatHandler
    let HospitalName: String
    var body: some View {
        ScrollView{
            LazyVStack{
                if !socket.ChatData.isEmpty{
                    ForEach(socket.ChatData.indices, id: \.self){
                        index in
                        ChatItemSwitchs(HospitalName:HospitalName ,item: $socket.ChatData[index])
                    }
                    .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .rotationEffect(Angle(degrees: 180))
                }
            }
        }
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .rotationEffect(Angle(degrees: 180))
        .background(Color.gray.opacity(0.1))
    }
}
struct ChatItemSwitchs: View {
    let HospitalName: String
    @Binding var item:ChatHandlerDataModel.ChatMessegeItem
    var body: some View {
        switch item.amI {
        case .user:
            MyChatItem(item: $item, hospitalName: HospitalName)
        case .other:
            EmptyView()
        case .sepDate:
            ChatdateView(time: item.chatDate)
        }
    }
}


