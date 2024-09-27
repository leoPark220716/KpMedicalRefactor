//
//  ChatVIewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI
import PhotosUI

struct ChatViewInputField: View {
    @ObservedObject var socket: ChatHandler
    @State var ChatText = ""
    @State var TabPlus = true
    @State private var importing = false
    @FocusState var chatField: Bool
    var body: some View{
        ChatInputView
    }
    private var ChatInputView: some View {
        VStack {
            HStack {
                Button{
                    TabPlus.toggle()
                    ChatText = ""
                } label: {
                    Image(systemName: TabPlus ? "plus" : "xmark")
                        .modifier(ChatInputFiledLeftButton())
                }
                HStack {
                    TextEditor(text: $ChatText)
                        .focused($chatField)
                        .onTapGesture {
                            self.TabPlus = true
                        }
                    if ChatText != "" || !socket.SendingImages.isEmpty {
                        Button{
                            handleSendButton()
                        }label: {
                            Image(systemName: "paperplane.circle.fill")
                                .modifier(ChatInputSendingButton())
                        }
                    }
                }
                .modifier(ChatInputHstackModifier())
            }
            .padding(.top, 4)
            if !TabPlus && socket.SendingImages.isEmpty {
                ChatPlusOptions
            }
            if !TabPlus && !socket.SendingImages.isEmpty {
                SendingImagesView
            }
            
        }
        .padding(.bottom, 10)
    }
    private func handleSendButton() {
        Task {
            if socket.HaveToCreateRoom {
                await socket.createChatRoom()
            }
            if !socket.SendingImages.isEmpty {
                socket.setpPreChatItem()
                socket.sendImageStart()
            } else {
                socket.sendTextMessege(chatText: ChatText)
            }
            ChatText = ""
        }
    }

    
    // 하단 파일 전송 옵션 화면
    private var ChatPlusOptions: some View {
        HStack {
            PhotosPicker(
                selection: $socket.selectedItems,
                maxSelectionCount: 20,
                selectionBehavior: .default,
                matching: .images,
                preferredItemEncoding: .automatic
            ) {
                SocialLoginButton(systemName: "photo.fill", color: .green.opacity(0.5))
                    .padding(.leading)
            }
            .onChange(of: socket.selectedItems) {
                handleSelectedItemsChange()
            }
            Button {
                importing = true
            } label: {
                SocialLoginButton(systemName: "folder.fill", color: .yellow.opacity(0.5))
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.item]
            ) { result in
                socket.appManager.showToast(message: "파일을 전송합니다.")
                socket.handleFileImport(result: result)
            }
            Spacer()
        }
        .cornerRadius(10)
        .background(Color.white)
        .padding(.top)
    }
    
    private var SendingImagesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(socket.SendingImages.indices, id: \.self) { index in
                    SendImageItemView(SendingImageArray: $socket.SendingImages, SendingImagesByte: $socket.SendingImagesByte, selectedItems: $socket.selectedItems, index: index, SendingImage: $socket.SendingImages[index])
                        .frame(width: 150, height: 200)
                }
            }
        }
    }
    private func handleSelectedItemsChange() {
        var sendingImages: [UIImage] = []
        var sendingImagesByte: [Data] = []
        let taskGroup = DispatchGroup()
        for imgs in socket.selectedItems {
            taskGroup.enter()
            imgs.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        let byteData = PngReturnByData_Img(data: data, img: image)
                        if byteData.1 {
                            sendingImages.append(image)
                            sendingImagesByte.append(byteData.0!)
                        } else {
                            socket.appManager.showToast(message: "사진 크기가 너무 큽니다.")
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                    socket.appManager.showToast(message: "사진을 가져올 수 없습니다.")
                }
                taskGroup.leave()
            }
        }
        taskGroup.wait()
        taskGroup.notify(queue: .main) {
            self.socket.SendingImages = sendingImages
            self.socket.SendingImagesByte = sendingImagesByte
        }
    }
    func PngReturnByData_Img(data: Data, img: UIImage) -> (Data?,Bool) {
        // 20MB를 바이트로 변환
        let maxSizeInBytes = 20 * 1024 * 1024
        
        // PNG 데이터 생성
        let pngData = data.isPNG() ? data : img.pngData()
        
        // 데이터 크기 확인
        if let currentDataSize = pngData?.count, currentDataSize > maxSizeInBytes {
            return (nil, false)
        }
        return (pngData ?? data,true)
    }
}
