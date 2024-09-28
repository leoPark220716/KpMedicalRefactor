//
//  OtherChatITem.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import SwiftUI

struct OthersChatItem: View {
    @ObservedObject var socket: ChatHandler
    @Binding var item: ChatHandlerDataModel.ChatMessegeItem
    let image: String
    var index: Int
    @State var imageUrls: [URL] = []
    let HospitalName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 3) {
            profileImageView()
            
            VStack(alignment: .leading, spacing: 3) {
                hospitalNameView()
                messageContentView()
            }
            .padding(.leading, 3)
            
            Spacer()
        }
        .padding(.top, topPadding())
        .padding(.bottom, bottomPadding())
        .padding(.leading)
        .padding(.trailing, 20)
    }
    
    @ViewBuilder
    private func profileImageView() -> some View {
        if shouldShowProfileImage() {
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .shadow(radius: 10, x: 5, y: 5)
        } else {
            Color.clear.frame(width: 40)
        }
    }
    
    private func shouldShowProfileImage() -> Bool {
        index < socket.ChatData.count - 1 && socket.ChatData[index + 1].amI != .other
    }
    
    @ViewBuilder
    private func hospitalNameView() -> some View {
        if shouldShowProfileImage() {
            Text(HospitalName)
                .font(.system(size: 12))
        }
    }
    
    @ViewBuilder
    private func messageContentView() -> some View {
        HStack(alignment: .bottom, spacing: 3) {
            switch item.type {
            case .text:
                if let message = item.messege {
                    Text(message)
                        .font(.system(size: 14))
                        .padding(10)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            case .photo:
                if let imageArray = item.ImageArray {
                    DynamicImageView(images: imageArray, totalWidth: 210, imageHeight: 70, oneItem: 210)
                        .cornerRadius(10)
                }
            case .file:
                if let fileURI = item.FileURI {
                    FileChatView(urlString: fileURI)
                }
            case .notice, .unowned, .share, .edit:
                EmptyView()
            case .move:
                if let message = item.messege {
                    NoticeChatView(message: message)
                }
            case .save:
                RequestConfirmChatView(hospitalName: HospitalName, item: $item, socket: socket)
                    .cornerRadius(10)
            }
            if item.showETC {
                Text(item.time)
                    .font(.system(size: 12))
            }
        }
        .padding(.top, 3)
    }
    
    private func topPadding() -> CGFloat {
        return (index < socket.ChatData.count - 1 && socket.ChatData[index + 1].amI == .other) ? 0 : 10
    }
    
    private func bottomPadding() -> CGFloat {
        return (!socket.ChatData.isEmpty && index > 0 && index < socket.ChatData.count && socket.ChatData[index - 1].amI == .user) ? 20 : 0
    }
}




struct RequestConfirmChatView: View {
    let hospitalName: String
    @Binding var item: ChatHandlerDataModel.ChatMessegeItem
    @State var buttonState = true
    @EnvironmentObject var appManager: NavigationRouter
    @ObservedObject var socket: ChatHandler
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("")
                            .bold()
                        Spacer()
                    }
                    if let message = item.messege {
                        Text("\(message)\n\n-요청구분 : 의료데이터 저장\n-요청기관 : \(hospitalName)\n-수신자 : \(appManager.name)")
                            .font(.system(size: 14))
                            .padding(10)
                            .padding(.top, 20)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    if let hash = item.hash {
                        Text("Tx : \(hash)")
                            .lineLimit(1)
                            .font(.system(size: 14))
                            .padding(.bottom, 10)
                            .padding(.horizontal, 10)
                    }
                    Button(action: {
                        switch item.type{
                        case .save:
                            if let timestemp = item.timeStemp{
                                socket.otp.toggle()
                                socket.setSaveContractData(stemp: timestemp, timeUUID: item.unixTime)
                                socket.otpType = .save
                            }
                            
                        case .share:
                            socket.otp.toggle()
                            socket.otpType = .share
                        case .edit:
                            socket.otp.toggle()
                            socket.otpType = .edit
                        default:
                            print("")
                        }
                        item.status = 1
                    }) {
                        Text("수락")
                            .bold()
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 4)
                            .padding()
                            .background(item.status == 1 ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(item.status == 1)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                .overlay(
                    Rectangle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(height: 30)
                        .clipped(),
                    alignment: .top
                )
                .cornerRadius(10)
                
                HStack {
                    Text("알림톡 도착")
                        .bold()
                        .font(.system(size: 14))
                        .padding(.leading, 10)
                        .padding(.top, 8)
                    Spacer()
                }
            }
        }
        .frame(width: 220)
    }
}
