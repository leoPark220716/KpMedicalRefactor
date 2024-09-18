//
//  DoctorListItemView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import SwiftUI

struct DoctorListItemView: View {
    let DoctorProfile: Doctor
    @State var WorkingState: Bool?
    init(DoctorProfile: Doctor) {
        self.DoctorProfile = DoctorProfile
        WorkingState = checkTimeIn(startTime: DoctorProfile.main_schedules[0].startTime1, endTime: DoctorProfile.main_schedules[0].endTime2)
    }
    var body: some View{
        VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text(DoctorProfile.name)
                            .font(.headline)
                            .bold()
                        HStack{
                            Image(systemName: "stopwatch")
                                .foregroundColor(WorkingState ?? false ? Color("AccentColor") : Color(.gray))
                                .modifier(HospitalDetailDoctorProfileText())
                            Text(WorkingState ?? false ? "진료중" : "진료종료")
                                .foregroundColor(WorkingState ?? false ? Color(.blue) : Color(.gray))
                                .modifier(HospitalDetailDoctorProfileText())
                            Text(WorkingState ?? false ? "\(DoctorProfile.main_schedules[0].startTime1)~\(DoctorProfile.main_schedules[0].endTime2)" : "")
                                .font(.subheadline)
                        }
                        .padding(.top, 2)
                        HStack {
                            ForEach(DoctorProfile.department_id.prefix(4), id: \.self) { id in
                                let intid = Int(id)
                                if let department = Department(rawValue: intid ?? 0) {
                                    Text(department.name)
                                        .truncationMode(.tail)
                                        .modifier(HospitalsDepartmentTexts())
                                }
                            }
                            if DoctorProfile.department_id.count > 4 {
                                Text("...")
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    AsyncImage(url: URL(string: DoctorProfile.icon)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView() // 이미지 로딩 중 표시할 뷰
                    }
                    .modifier(HospitalDetailDoctorImageModify())
                }
                .padding(.horizontal)
        }
    }
    private func checkTimeIn(startTime: String, endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HHmm"
        guard let now = Int(dateFormatter.string(from: Date())),
              let st = Int(startTime.replacingOccurrences(of: ":", with: "")),
              let en = Int(endTime.replacingOccurrences(of: ":", with: "")) else {
            // 날짜 변환이 실패했을 경우
            return false
        }
        return now >= st && now <= en
    }
}
