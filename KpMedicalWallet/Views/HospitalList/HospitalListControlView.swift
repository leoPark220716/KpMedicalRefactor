//
//  HospitalListControlView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import SwiftUI

struct HospitalListControlView: View {
    @ObservedObject var locationService: LocationService
    @ObservedObject var viewModel: HospitalListMainViewModel
    var body: some View {
        VStack{
            Button{
                viewModel.goToKeyWordSearchView()
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .modifier(HospitalsFindSearchFieldGuaidLine())
                    Text(PlistManager.shared.string(forKey: "find_hospital_guaid_line"))
                        .modifier(HospitalsFindSearchFieldGuaidLine())
                        Spacer()
                }
                .modifier(HospitalsFindSearchFieldModifier())
            }
            HStack{
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .padding(.leading,20)
                        .foregroundColor(.pink)
                    if let addres = locationService.address_Naver{
                        Text("\(addres)")
                            .font(.system(size: 14))
                    }else{
                        Text(PlistManager.shared.string(forKey: "find_hospital_address_null"))
                            .font(.system(size: 14))
                    }
                }
                .padding(.top,10)
                Spacer()
            }
            HStack{
                Picker("Sorting Criteria",selection: $viewModel.selectedTab){
                    Text(PlistManager.shared.string(forKey: "sorting_criteria1")).tag(0)
                    Text(PlistManager.shared.string(forKey: "sorting_criteria2")).tag(1)
                }
                .modifier(HospitalsFindPiker())
                Spacer()
                Button{
                    viewModel.departSheetShow.toggle()
                } label: {
                    HStack{
                        Text(viewModel.selectedDepartment?.name ?? PlistManager.shared.string(forKey: "find_hospital_department_default"))
                            .modifier(HospitalsFindDepartmentText())
                        Image(systemName: "control")
                            .modifier(HospitalsFindDepartmentDirection())
                    }
                    .modifier(HospitalsFindDepartmentHStack())
                }
                .sheet(isPresented: $viewModel.departSheetShow){
                    departmentsChooseSheetView(selectedDepartment: $viewModel.selectedDepartment, onDepartmentSelect: { department in
                        viewModel.selectedDepartment = department
                        viewModel.selectedTab = viewModel.selectedTab
                    })
                    .presentationDetents([.height(400),.medium,.large])
                    .presentationDragIndicator(.automatic)
                }
            }
        }
    }
}

struct HospitalListItemView: View {
    @Binding var hospital: Hospitals
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
                        .font(.headline)
                        .bold()
                    Text(hospital.location)
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
