//
//  HospitalListMainViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import Foundation

class HospitalListMainViewModel:HospitalListCache, ObservableObject{
    @Published var selectedTab: Int = 0 {
        didSet{
            OrderByUpdate()
        }
    }
    @Published var searchText: String = "" {
        didSet{
            KeyWordUpdate()
        }
    }
    @Published var isLoading = false
    @Published var selectedDepartment: Department?
    @Published var departSheetShow: Bool = false
    @Published var hospitalList: [Hospitals] = []
    
    var requestQuery = HospitalRequestQuery()
    var appManager: NavigationRouter?
    var changedQuery = false
    var returnStringURL: String {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "start", value: "\(requestQuery.start)"),
            URLQueryItem(name: "limit", value: "\(requestQuery.limit)"),
            URLQueryItem(name: "orderBy", value: requestQuery.orderby),
            URLQueryItem(name: "x", value: requestQuery.x_tude),
            URLQueryItem(name: "y", value: requestQuery.y_tude),
            URLQueryItem(name: "keyword", value: requestQuery.key_word),
            URLQueryItem(name: "department_id", value: requestQuery.department)
        ].filter { $0.value != nil } // nil 값 필터링
        // URLComponents를 통해 안전하게 URL 생성
        return components.url?.query ?? ""
    }
    
    @MainActor
    func setDepartment(department: Department){
        self.selectedDepartment = department
    }
    @MainActor
    func resetHospitalListArray(){
        hospitalList = []
    }
    @MainActor
    func loadingChange(status: Bool){
        isLoading = status
    }
    func seachByCategoryAction(){
        Task{
            do{
                await loadingChange(status: true)
                try await getHospitalList()
                await loadingChange(status: false)
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(PlistManager.shared.string(forKey: "hospitl_list_setup")))
            }
        }
    }
    private func OrderByUpdate(){
        switch selectedTab{
        case 1:
            changedQuery = true
            requestQuery.orderby = "distance"
        default :
            requestQuery.orderby = "name"
        }
    }
    private func KeyWordUpdate(){
        requestQuery.key_word = searchText
    }
    func queryChange(x:String? = nil, y:String? = nil, department: Department? = nil){
        changedQuery = true
        requestQuery.start = 0
        if let x = x{
            requestQuery.x_tude = x
        }
        if let y = y{
            requestQuery.y_tude = y
        }
        if let department = department{
            if department.rawValue == 9999{
                requestQuery.department = ""
            }else{
                requestQuery.department = String(department.rawValue)
            }
        }
        print(requestQuery)
    }
    // onAppear 호출 함수
    func hospitalListSetUp(){
        print("✅hospitalListSetUp")
        Task{
            await loadingChange(status: true)
            //            기간이 지난 캐시파일 삭제
            clearExpiredCacheFiles()
            if let cacheHospitals = loadHospitalListFromCache(){
                await MainActor.run {
                    hospitalList = cacheHospitals
                }
                await loadingChange(status: false)
                return
            }
            await loadingChange(status: false)
            do{
                try await getHospitalList()
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(PlistManager.shared.string(forKey: "hospitl_list_setup")))
            }
        }
    }
    
    func getCachFile(){
        print("✅getCachFile")
        Task{
            clearExpiredCacheFiles()
            if let cacheHospitals = loadHospitalListFromCache(){
                await MainActor.run {
                    hospitalList = cacheHospitals
                }
            }
        }
    }
    
    // 페이지네이션 시 불러오는 병원 리스트
    func addHospitalList(){
        print("✅addHospitalList")
        Task{
            do{
                requestQuery.start += hospitalList.count
                try await getHospitalList()
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(PlistManager.shared.string(forKey: "hospitl_list_setup")))
            }
        }
        
    }
    // 병원 리스트 Http 요청
    private func getHospitalList() async throws{
        print("✅getHospitalList")
        do{
            let request = try hospitalListRequestStruct()
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest(encoded: true)
            if response.success, let data = response.data?.data{
                await MainActor.run {
                    hospitalList.append(contentsOf: data.hospitals)
                }
                if !changedQuery {
                    saveHospitalListToCache(data.hospitals)
                }
            }
        }catch{
            throw error
        }
    }
    // http 요청 객체
    private func hospitalListRequestStruct() throws -> http<Empty?,KPApiStructFrom<Hospital_Data>>{
        print("✅hospitalListRequestStruct")
        guard let token = appManager?.jwtToken else{
            throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "viewModelSetupFalse")) \(UserVariable.APP_VERSION())")
        }
        return http<Empty?,KPApiStructFrom<Hospital_Data>>(
            method: "GET",
            urlParse: "hospitals?\(returnStringURL)",
            token: token,
            UUID: UserVariable.GET_UUID()
        )
    }
    
    @MainActor
    func goHospitalDetailView(index: Int){
        appManager?.push(to: .userPage(item: UserPage(page: .HospitalDetail),Hospital: hospitalList[index]))
    }
}


