//
//  HomViewModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import SwiftUI

struct SuggestImage: ViewModifier {
    let geo: GeometryProxy
    
    func body(content: Content) -> some View {
        content
            .frame(width: geo.size.height * 0.13, height: geo.size.height * 0.13)
            .cornerRadius(25)
            .shadow(radius: 10, x: 5, y: 5)
            .aspectRatio(contentMode: .fit)
    }
}

extension Image {
    func suggestImageModifier(geo: GeometryProxy) -> some View {
        self
            .resizable()
            .modifier(SuggestImage(geo: geo))
    }
}


