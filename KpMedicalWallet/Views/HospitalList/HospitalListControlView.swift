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
            HStack {
                Image(systemName: "magnifyingglass")
                    .modifier(HospitalsFindSearchFieldGuaidLine())
                TextField(PlistManager.shared.string(forKey: "find_hospital_guaid_line"),text: $viewModel.searchText)
                    .modifier(HospitalsFindSearchFieldGuaidLine())
                    .onSubmit {
                        viewModel.changedQuery = true
                        viewModel.resetHospitalListArray()
                        viewModel.seachByCategoryAction()
                    }
                Spacer()
            }
            .modifier(HospitalsFindSearchFieldModifier())
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
                .onChange(of: viewModel.selectedTab) {
                    if viewModel.selectedTab == 1 {
                        viewModel.queryChange(x: locationService.longitude, y: locationService.latitude)
                    }else{
                        viewModel.queryChange(x: "", y: "")
                    }
                    viewModel.resetHospitalListArray()
                    viewModel.seachByCategoryAction()
                    
                }
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
                        viewModel.setDepartment(department: department)
                        viewModel.queryChange(department: department)
                        viewModel.resetHospitalListArray()
                        viewModel.seachByCategoryAction()
                        
                    })
                    .presentationDetents([.height(400),.medium,.large])
                    .presentationDragIndicator(.automatic)
                }
            }
        }
    }
}

