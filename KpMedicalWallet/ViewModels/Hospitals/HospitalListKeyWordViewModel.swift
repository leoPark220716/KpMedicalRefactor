//
//  HospitalListKeyWordViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/17/24.
//

import Foundation
import Combine

class HospitalListKeyWordViewModel: HospitalListMainViewModel{
    
    @Published var isSearching: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    let searchTextPublisher = PassthroughSubject<String, Never>()
    
    override init() {
        super.init()
        searchTextPublisher
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] completedText in
                self?.requestQuery.key_word = completedText
                self?.seachByCategoryAction()
            }
            .store(in: &cancellables)
    }
    
    override func seachByCategoryAction(){
        super.seachByCategoryAction()
        
    }
}
