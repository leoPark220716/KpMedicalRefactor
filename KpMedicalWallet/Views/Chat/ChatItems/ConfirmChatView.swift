//
//  ConfirmChatView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ConfirmChatView: View {
    var message: String
    var hospitalName: String
    var hash: String
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                VStack(alignment: .leading,spacing: 3){
                    HStack{
                        Text("")
                            .bold()
                        Spacer()
                    }
                    Text("\(message)\n\n-요청구분 : 의료데이터 저장\n-요청기관 : \(hospitalName)")
                        .font(.system(size: 14))
                        .padding(.horizontal,10)
                        .padding(.top,10)
                        .padding(.top,20)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    Text("Tx : \(hash)")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .padding(.bottom,10)
                        .padding(.horizontal,10)
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


