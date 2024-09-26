//
//  ChatVIewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ChatViewInputField: View {
    @ObservedObject var socket: ChatHandler
    @State var ChatText = ""
    @State var TabPlus = true
    @State var SendingImages: [UIImage] = []
    @State var SendingImagesByte: [Data] = []
    @FocusState private var chatField: Bool
    var body: some View{
        ChatInputView
    }
    private var ChatInputView: some View {
        VStack {
            HStack {
                Image(systemName: TabPlus ? "plus" : "xmark")
                    .modifier(ChatInputFiledLeftButton())
                HStack {
                    TextEditor(text: $ChatText)
                        .focused($chatField)
                        .onTapGesture {
                            self.TabPlus = true
                        }
                    if ChatText != "" || !SendingImages.isEmpty {
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
            if !TabPlus && SendingImages.isEmpty {
//                ChatPlusOptions
            }
            if !TabPlus && !SendingImages.isEmpty {
//                SendingImagesView
            }
        }
        .padding(.bottom, 10)
    }
    private func handleSendButton(){
        if !SendingImages.isEmpty{
            
        }else if SendingImages.isEmpty{
            socket.sendTextMessege(chatText: ChatText)
        }else{
            
        }
        ChatText = ""
    }
}
