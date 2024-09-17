//
//  HospitalDetailView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/17/24.
//

import SwiftUI

struct HospitalDetailView: View {
    var body: some View {
        
        
            GeometryReader { geometry in
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        NaverMapTestView()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3) // 원하는 높이로 설정
                            .cornerRadius(20)
                        Spacer()
                    }
                    
                    Spacer()
                }
                
            }
        
        
    }
}

#Preview {
    HospitalDetailView()
}
