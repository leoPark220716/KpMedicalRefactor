//
//  HospitalListViewItem.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/17/24.
//

import SwiftUI


struct HospitalListItemView: View {
    let hospital: Hospitals
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
    @State var WorkingState: Bool?
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(hospital.hospital_name)
                        .foregroundStyle(Color.black)
                        .font(.headline)
                        .bold()
                    Text(hospital.location)
                        .foregroundStyle(Color.black)
                        .font(.subheadline)
                        .bold()
                    HStack{
                        Image(systemName: "stopwatch")
                            .foregroundColor(WorkingState ?? false ? Color("AccentColor") : Color(.gray))
                            .font(.subheadline)
                            .bold()
                        Text(WorkingState ?? false ? "진료중" : "진료종료")
                            .foregroundColor(WorkingState ?? false ? Color(.blue) : Color(.gray))
                            .font(.subheadline)
                            .bold()
                        Text(WorkingState ?? false ? "\(hospital.start_time)~\(hospital.end_time)" : "")
                            .font(.subheadline)
                    }
                    .padding(.top, 2)
                    HStack {
                        ForEach(hospital.department_id, id: \.self) { id in
                            let intid = Int(id)
                            if let department = Department(rawValue: intid ?? 0) {
                                Text(department.name)
                                    .truncationMode(.tail)
                                    .modifier(HospitalsDepartmentTexts())
                            }
                        }
                    }
                }
                Spacer()
                AsyncImage(url: URL(string: hospital.icon)) { image in
                    image.resizable() // 이미지를 resizable로 만듭니다.
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView() // 이미지 로딩 중 표시할 뷰
                }
                .frame(width: 90, height: 90)
                .cornerRadius(25)
                .padding()
                .shadow(radius: 10, x: 5, y: 5)
            }
            
        }
        .background(Color.white)
        .padding(.vertical,5)
        .onAppear{
            WorkingState = checkTimeIn(startTime: hospital.start_time, endTime: hospital.end_time)
        }
    }
}
