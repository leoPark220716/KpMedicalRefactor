//
//  ReservationSymptomView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI

struct ReservationSymptomView: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ZStack{
                    TextEditor(text: $viewModel.symptom)
                        .frame(height: geo.size.height * 0.3)
                        .font(.custom("Helvetica Nenu", size: 15))
                        .background(Color.white) // 배경 색 설정
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .onChange(of: viewModel.symptom) {
                            viewModel.limitText()
                        }
                    Spacer()
                    if viewModel.symptom.isEmpty{
                        Text("증상을 입력해주세요.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Spacer()
                    Text("(\(viewModel.symptom.count)/\(viewModel.maxCharacters))")
                        .font(.custom("Helvetica Nenu", size: 15))
                        .foregroundColor(viewModel.maxCharacters+1 <= viewModel.symptom.count ? .red : .blue)
                        .padding(.trailing,30)
                }
                Spacer()
                Button{
                    viewModel.setSymptomData()
                    viewModel.goToReservationFinalView()
                }label: {
                    Text("에약하기")
                        .modifier(ReservationButtonStyleModifier(State: $viewModel.SymptomAccess))
                    
                }
                .disabled(!viewModel.SymptomAccess)
                .padding(.horizontal)
                
            }.navigationTitle("증상 작성")
        }
        
        
    }
}

struct ReservationSymptomView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var env = HospitalReservationModel()
        ReservationSymptomView()
            .environmentObject(env)
    }
}
