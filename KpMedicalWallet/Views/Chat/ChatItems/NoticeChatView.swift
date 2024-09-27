//
//  NoticeChatView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import SwiftUI

struct NoticeChatView: View {
    var message: String
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                VStack(alignment: .leading,spacing: 3){
                    HStack{
                        Text("")
                            .bold()
                        Spacer()
                    }
                    Text(message)
                        .font(.system(size: 14))
                        .padding(10)
                        .padding(.top,20)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                .overlay(
                    Rectangle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(height:30)
                        .clipped()
                    , alignment: .top
                )
                .cornerRadius(10)
                HStack{
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

#Preview {
    NoticeChatView(message:"asdf")
}
