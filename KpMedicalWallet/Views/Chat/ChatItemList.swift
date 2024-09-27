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
                        Button{
                            socket.goToPhotoView(item: socket.ChatData[index])
                        }label: {
                            ChatItemSwitchs( HospitalName:HospitalName, item: $socket.ChatData[index], items: $socket.ChatData, index:index,Image: "https://public-kp-medicals-test.s3.ap-northeast-2.amazonaws.com/hospital_icon/default_hospital.png")
                        }
                        .onAppear{
                            if socket.chatId != 0 && index == socket.ChatData.count - 3 {
                                socket.pageNationChatDataGet()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .rotationEffect(Angle(degrees: 180))
                }
            }
        }
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .rotationEffect(Angle(degrees: 180))
        .padding(.bottom)
        .background(Color.gray.opacity(0.1))
    }
}
struct ChatItemSwitchs: View {
    let HospitalName: String
    @Binding var item:ChatHandlerDataModel.ChatMessegeItem
    @Binding var items:[ChatHandlerDataModel.ChatMessegeItem]
    var index: Int
    let Image: String
    var body: some View {
        switch item.amI {
        case .user:
            MyChatItem(item: $item, hospitalName: HospitalName)
        case .other:
            OthersChatItem(item: $item, items: $items, image: Image, index: index, HospitalName: HospitalName)
        case .sepDate:
            ChatdateView(time: item.chatDate)
        }
    }
}


