//
//  HospitalDetailView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/17/24.
//

import SwiftUI
import NMapsMap

struct HospitalDetailView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel = HospitalReservationModel()
    let hospitalInfo: Hospitals
    var body: some View {
        GeometryReader { geometry in
            VStack{
                ScrollView{
                HospitalDetailTop(viewModel: viewModel, hospitalInfo: hospitalInfo, WorkingState: viewModel.checkTimeIn(startTime: hospitalInfo.start_time, endTime: hospitalInfo.end_time), geo: geometry)
                    Divider()
                        .frame(height: 1)
                        .foregroundStyle(Color(.init(white: 0, alpha: 0.2)))
                        .cornerRadius(10)
                    HospitalDetailContent(viewModel: viewModel, geo: geometry)
                }
                HStack{
                    Spacer()
                    Text("상담하기")
                        .modifier(HospitalDetailButtonModify(back: Color.white, fore: Color.blue.opacity(0.5)))
                    Text("예약하기")
                        .modifier(HospitalDetailButtonModify(back: Color.blue.opacity(0.5), fore: Color.white))
                    Spacer()
                }
                .padding(.bottom)
            }
            .onAppear{
                viewModel.setManagerHospitalId(hospitalId: hospitalInfo.hospital_id, appManager: appManager)
                viewModel.setUpDetailView()
            }
            
            
        }
    }
}


struct HospitalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        let hospital = Hospitals(hospital_id: 27483, hospital_name: "샘신경정신과의원", icon: "https://public-kp-medicals-test.s3.ap-northeast-2.amazonaws.com/hospital_icon/default_hospital.png", location: "서울특별시 서초구 사평대로55길 8, 3층 (반포동, 신영빌딩)", department_id: ["1"], start_time: "00:00", end_time: "20:00")
        HospitalDetailView(hospitalInfo: hospital)
            .environmentObject(router)
    }
}
struct HospitalDetailTop: View{
    @ObservedObject var viewModel: HospitalReservationModel
    let hospitalInfo: Hospitals
    let WorkingState: Bool
    let geo: GeometryProxy
    var body: some View{
        VStack(alignment: .leading){
            ZStack {
                if !viewModel.hospitalIamges.isEmpty{
                    AsyncImage(url: URL(string: viewModel.hospitalIamges[0])) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .clipped()
                            
                    } placeholder: {
                        ProgressView() // 이미지 로딩 중 표시할 뷰
                    }
                }else{
                    ProgressView() // 이미지 로딩 중 표시할 뷰
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Text(hospitalInfo.hospital_name)
                .font(.system(size: 20))
                .padding([.top,.leading])
                .bold()
            HStack{
                Image(systemName: "stopwatch")
                    .foregroundColor(WorkingState ? Color("AccentColor") : Color(.gray))
                    .font(.system(size: 15))
                    .bold()
                Text(WorkingState ? "진료중" : "진료종료")
                    .foregroundColor(WorkingState ? Color(.blue) : Color(.gray))
                    .font(.system(size: 15))
                    .bold()
                Text(WorkingState ? "\(hospitalInfo.start_time)~\(hospitalInfo.end_time)" : "")
                    .font(.system(size: 15))
            }
            .padding(.leading)
            .padding(.vertical,4)
            HStack{
                if hospitalInfo.department_id.count > 5 {
                    ForEach(hospitalInfo.department_id.prefix(3), id: \.self) { id in
                        let intid = Int(id)
                        if let department = Department(rawValue: intid ?? 0) {
                            Text(department.name)
                                .truncationMode(.tail)
                                .modifier(HospitalsDepartmentTexts())
                        }
                    }
                    HStack{
                        Text(PlistManager.shared.string(forKey: "hospital_detail_department_show_all"))
                        Image(systemName: "greaterthan.circle.fill")
                    }
                    .modifier(HospitalsDepartmentTexts())
                }
                else{
                    ForEach(hospitalInfo.department_id, id: \.self) { id in
                        let intid = Int(id)
                        if let department = Department(rawValue: intid ?? 0) {
                            Text(department.name)
                                .truncationMode(.tail)
                                .modifier(HospitalsDepartmentTexts())
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom,2)
        }
        .padding(.top)
        .background(Color.white)
                
    }
}
