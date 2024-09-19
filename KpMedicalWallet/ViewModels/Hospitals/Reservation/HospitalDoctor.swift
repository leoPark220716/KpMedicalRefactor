//
//  HospitalDoctor.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation

class HospitalDoctor: HospitalReservationTime{
    @Published var DoctorProfileInChooseView: [Doctor] = []
    var isSetDate: Bool {
        return reservationData.date != ""
    }
    
    @MainActor
    func didntSetDateDoctorListSet(){
        DoctorProfileInChooseView = GetDepartHaveDoctor()
    }
    func didSetDateDoctorListSet() async{
        let DoctorArray = GetDepartHaveDoctor()
        let workingStaffId = findWorkingStaffIds(on: reservationData.date, from: DoctorArray)
        await MainActor.run {
            DoctorProfileInChooseView = GetDoctorGetIDArry(staff_id: workingStaffId)
        }
    }
    @MainActor
    func setReservationDoctor(index: Int) -> Bool{
        print(PlistManager.shared.string(forKey:"doctor_schedules_isEmpty"))
        if DoctorProfileInChooseView[index].main_schedules.isEmpty{
            appManager?.displayError(ServiceError: TraceUserError.managerFunction(PlistManager.shared.string(forKey:"doctor_schedules_isEmpty")))
            return false
        }else{
            reservationData.time_slot = DoctorProfileInChooseView[index].main_schedules[0].timeSlot
            reservationData.doc_name = DoctorProfileInChooseView[index].name
            reservationData.staff_id = DoctorProfileInChooseView[index].staff_id
            return true
        }
    }
    
    func setReservationDoctorList(){
        Task{
            switch isSetDate{
            case true:
                await didSetDateDoctorListSet()
            case false:
                await didntSetDateDoctorListSet()
            }
        }
        
    }
}


