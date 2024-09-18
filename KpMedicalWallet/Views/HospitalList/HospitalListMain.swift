//
//  HospitalListMain.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import SwiftUI

struct HospitalListMain: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var locationService = LocationService()
    @StateObject var viewModel = HospitalListMainViewModel()
    var body: some View {
        VStack{
            HospitalListControlView(locationService: locationService, viewModel: viewModel)
                .padding(.vertical)
                .background(Color("backColor"))
            HospitalViewMainListContent(viewModel: viewModel)
        }
        .onAppear{
            locationService.getRequestPermission()
            viewModel.appManager = appManager
            viewModel.hospitalListSetUp()
        }
        .navigationTitle(PlistManager.shared.string(forKey: "find_hospital_nav_title"))
    }
}

struct HospitalListMain_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        HospitalListMain()
            .environmentObject(router)
    }
}
