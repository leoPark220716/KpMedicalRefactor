//
//  SendingImageView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import SwiftUI

import PhotosUI

struct SendImageItemView: View {
    @Binding var SendingImageArray: [UIImage]
    @Binding var SendingImagesByte: [Data]
    @Binding var selectedItems: [PhotosPickerItem]
    var index: Int
    @Binding var SendingImage: UIImage
    var body: some View {
        VStack{
            ZStack(alignment: .topTrailing){
                Image(uiImage: SendingImage)
                    .resizable()  // 이미지 크기 조절 가능하도록 설정
                    .aspectRatio(contentMode: .fill)  // 내용을 프레임에 맞추어 채움
                    .frame(width: 150, height: 200)
                    .clipped()
                Button(action: {
                    // 'X' 버튼이 눌렸을 때 실행할 액션
                    print("Close button tapped")
                    DispatchQueue.main.async {
                        SendingImageArray.remove(at: index)
                        SendingImagesByte.remove(at: index)
                        selectedItems.remove(at: index)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")  // 시스템 아이콘 사용
                        .foregroundColor(.white)  // 아이콘 색상 설정
                        .background(Color.blue)  // 배경색 추가
                        .clipShape(Circle())  // 원형 클립
                        .font(.system(size: 24))
                }
                .padding([.top, .trailing], 10)
            }
        }
    }
}


