//
//  HospitalDetailContentView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import SwiftUI

struct HospitalDetailContent: View {
    @State private var selection = Selection.Intro
    @ObservedObject var viewModel: HospitalReservationModel
    let geo: GeometryProxy
    var body: some View {
        contentView()
    }
    @ViewBuilder
    private func contentView() -> some View {
        VStack(alignment: .leading){
            HStack{
                Button{
                    selection = .Intro
                } label: {
                    VStack{
                        Text("병원소개")
                            .modifier(HospitalDetailPickerText(selection: $selection, set: .Intro))
                        Rectangle()
                            .modifier(HospitalDetailPickerUnderBar(selection: $selection,set: .Intro))
                    }
                    .background(Color.white)
                }
                Button{
                    selection = .doc
                } label: {
                    VStack{
                        Text("의료진")
                            .modifier(HospitalDetailPickerText(selection: $selection,set: .doc))
                        Rectangle()
                            .modifier(HospitalDetailPickerUnderBar(selection: $selection, set: .doc))
                    }
                    .background(Color.white)
                }
                
                
            }
            switch selection {
            case .Intro:
                HospitalDetailViewIntro(viewModel: viewModel, geo: geo)
            case .doc:
                DoctorListView(doctorProfile: $viewModel.DoctorProfile)
                
            }
        }
        
    }
    enum Selection {
        case Intro, doc
    }
}

struct DoctorListView: View{
    @Binding var doctorProfile: [Doctor]
    var body: some View{
        ForEach(doctorProfile.indices, id: \.self){ index in
            DoctorListItemView(DoctorProfile: doctorProfile[index])
            Divider()
                .frame(height: 1)
                .foregroundColor(Color(.init(white: 0, alpha: 0.2)))
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}
struct HospitalDetailViewIntro:View {
    @ObservedObject var viewModel: HospitalReservationModel
    let geo: GeometryProxy
    var body: some View {
        Text("진료시간")
            .bold()
            .padding(.leading,30)
            .padding(.top,8)
        HospitalScheduleView(HospitalSchedules: $viewModel.HospitalSchedules)
        Divider()
            .frame(height: 1)
            .foregroundColor(Color(.init(white: 0, alpha: 0.2)))
            .cornerRadius(10)
            .padding()
        Text("전화번호")
            .bold()
            .padding(.leading,30)
            .padding(.top,8)
        HStack{
            Text(viewModel.telephone)
                .padding(.leading,30)
            Spacer()
            Text("전화하기")
                .font(.system(size: 13))
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                .cornerRadius(10)
                .foregroundColor(Color("AccentColor"))
                .onTapGesture {
                    let telephone = "tel://"
                    let formattedString = telephone + viewModel.telephone
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                }
                .padding(.trailing,30)
        }
        Divider()
            .frame(height: 1)
            .foregroundColor(Color(.init(white: 0, alpha: 0.2)))
            .cornerRadius(10)
            .padding()
        Text("위치")
            .bold()
            .padding(.leading,30)
            .padding(.top,8)
        Text(viewModel.address)
            .font(.system(size: 13))
            .padding(.leading,30)
            .padding(.top,8)
        HStack{
            Spacer()
            NMFMapViewRepresentable(coord: $viewModel.mapCoord)
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.3) // 원하는 높이로 설정
                .cornerRadius(20)
            Spacer()
        }
        
    }
}
