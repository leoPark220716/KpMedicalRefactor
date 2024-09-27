//
//  MyChatItem.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//
import SwiftUI

struct MyChatItem: View {
    @Binding var item: ChatHandlerDataModel.ChatMessegeItem
    let hospitalName: String

    var body: some View {
        HStack(alignment: .bottom, spacing: 3) {
            Spacer()
            VStack(alignment: .trailing) {
                if item.progress && item.type != .photo {
                    ProgressView()
                } else {
                    if !item.progress {
                        unreadCountView
                        timeView
                    }
                }
            }
            contentView
        }
        .padding(.trailing)
        .padding(.leading, 20)
        .padding(.bottom, 3)
    }

    // Unread count view
    private var unreadCountView: some View {
        if !item.ReadCount {
            return Text("1")
                .foregroundStyle(.red)
                .font(.system(size: 12))
        } else {
            return Text("")
                .foregroundStyle(.red)
                .font(.system(size: 12))
        }
    }

    // Time view
    private var timeView: some View {
        if item.showETC {
            return Text(item.time)
                .font(.system(size: 12))
        } else {
            return Text("")
                .font(.system(size: 12))
        }
    }

    // Content view based on item type
    @ViewBuilder
    private var contentView: some View {
        switch item.type {
        case .text:
            if let message = item.messege {
                Text(message)
                    .font(.system(size: 14))
                    .padding(10)
                    .foregroundColor(.black)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(10)
            }
        case .photo:
            if item.progress {
                ImageProgressView()
            } else if let imageArray = item.ImageArray {
                DynamicImageView(images: imageArray, totalWidth: 270, imageHeight: 90, oneItem: 270)
                    .cornerRadius(10)
            }
        case .file:
            if let fileURI = item.FileURI {
                FileChatView(urlString: fileURI)
            }
        case .notice:
            if let message = item.messege, let hash = item.hash {
                ConfirmChatView(message: message, hospitalName: hospitalName, hash: hash)
                    .cornerRadius(10)
            }
        case .unowned, .share, .edit:
            EmptyView()
        case .move:
            EmptyView()
        case .save:
            EmptyView()
        }
    }
}
