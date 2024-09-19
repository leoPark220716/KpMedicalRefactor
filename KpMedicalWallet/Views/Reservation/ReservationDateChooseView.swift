//
//  ReservationDateChooseView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI

struct ReservationDateChooseView: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var body: some View {
        VStack{
            Spacer()
            if viewModel.isReadyToShowCalendar{
                CustomCalendarView(viewModel: viewModel)
            }
            Spacer()
            Divider()
                .modifier(ReservationDividerStyleModifier())
            HStack{
                VStack{
                    Text(viewModel.formatDate())
                        .modifier(ReservationGuaidLineStyleModifier())
                    Text(viewModel.reservationData.doc_name)
                        .modifier(ReservationGuaidLineStyleModifier())
                }
                Spacer()
                Button{
                    viewModel.DateReservationSet()
                    viewModel.DateViewGoToNextView()
                } label: {
                    Text("확인")
                        .modifier(ReservationStateButtonStyleModifier(State: $viewModel.scheduleButtonState))
                        .padding(.horizontal)
                }
                .disabled(!viewModel.scheduleButtonState)
                
            }
            
        }
        .navigationTitle("날짜를 선택해주세요")
        .onAppear{
            viewModel.caseChooseDoctor()
        }
    }
}

struct ReservationDateChooseView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var env = HospitalReservationModel()
        ReservationDateChooseView()
            .environmentObject(env)
    }
}
struct CustomCalendarView: View {
    @ObservedObject var viewModel: HospitalReservationModel
    @State private var currentMonth: Date = Date() // 현재 보고 있는 달을 나타내는 상태
    private var year: Int { Calendar.current.component(.year, from: currentMonth) }
    private var month: Int { Calendar.current.component(.month, from: currentMonth) }
    private var daysInMonth: Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        return range.count
    }
    private var firstDayWeekday: Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    private var allDays: [(id: Int, day: Int)] {
        var days: [(id: Int, day: Int)] = []
        // 첫 번째 날 이전의 빈 날짜를 추가
        for i in 0..<(firstDayWeekday - 1) {
            days.append((id: -i, day: 0)) // 여기서 고유한 ID를 부여
        }
        // 실제 날짜를 추가
        for day in 1...daysInMonth {
            days.append((id: day, day: day)) // 실제 날짜에 대해 ID 사용
        }
        return days
    }
    private var specificDates: [Date]
    private var mandatoryDates: [Date]
    
    init(viewModel: HospitalReservationModel) {
        self.viewModel = viewModel
        self.specificDates = viewModel.closeDate.compactMap { dateString in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.date(from: dateString)
            }
        self.mandatoryDates = viewModel.openDate.compactMap { dateString in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.date(from: dateString)
            }
        }
    var body: some View {
        VStack {
            // 년도와 월 표시
            HStack {
                Button(action: {
                    // 이전 달로 이동
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(String(format: "%d년 %d월", year, month))
                    .font(.system(size: 25))
                Spacer()
                Button(action: {
                    // 다음 달로 이동
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding([.horizontal,.bottom])
            
            // 요일 헤더
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .black))
                }
            }
            // 날짜 표시
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(allDays, id: \.id) { item in // 여기서 .id를 사용합니다.
                    if item.day > 0 {
                        let date = getDateFor(day: item.day) // 실제 날짜를 생성합니다.
                        DayView(date: date, selectedDate: $viewModel.selectedDate, today: Date(),currentMonth: $currentMonth, disabledDaysOfWeek: viewModel.disalbeWeek, specificDates: specificDates,mandatoryDates: mandatoryDates)
                    } else {
                        Text("") // 빈 날짜를 표시합니다.
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .id(currentMonth) // 이 부분이 중요
        }
        .padding()
    }
    private func getDateFor(day: Int) -> Date {
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    private func changeMonth(by amount: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: amount, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

struct DayView: View {
    var date: Date
    @Binding var selectedDate: Date?
    var today: Date
    @Binding var currentMonth: Date
    var disabledDaysOfWeek: Set<Int>
    var specificDates: [Date] //무족건 비활성화. 휴가
    var mandatoryDates: [Date] // 무족건 활성화 오늘 이후라면
    var body: some View {
        let dayComponent = Calendar.current.component(.day, from: date)
        let isCurrentMonth = Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
        let weekday = Calendar.current.component(.weekday, from: date)
        let isWeekend = disabledDaysOfWeek.contains(weekday)
        let isSpecificDate = specificDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        let isMandatoryDate = mandatoryDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        let isDisabled = !isCurrentMonth || date < today || (!isMandatoryDate && (isSpecificDate || isWeekend))
        Text("\(dayComponent)")
            .frame(width: 30, height: 30)
            .background(
                Group {
                    if isCurrentMonth && date == selectedDate {
                        Circle().fill(Color.blue) // 선택된 날짜이고 현재 월인 경우 파란색 원
                    } else {
                        Circle().stroke(Color.clear) // 그 외 경우 투명한 원
                    }
                }
            )
            .foregroundColor(isDisabled ? .gray : (isCurrentMonth && date == selectedDate ? .white : .black))
            .onTapGesture {
                if !isDisabled {
                    selectedDate = date
                }
            }
    }
}

