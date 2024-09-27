//
//  ChatImageView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import SwiftUI

struct ChatImageViewer: View {
    let item: ImagesSepView
    var body: some View {
        TabView {
            // URL 자체를 고유 식별자로 사용하여 ForEach를 초기화합니다.
            ForEach(item.Images, id: \.self) { url in
                PagedView(url: url)
            }
        }
        .onAppear{
            print("✅이미지 URL 확인\(item.Images)")
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct PagedView: View {
    var url: URL
    var body: some View {
        URLImageForView(url:url)
        
    }
}
