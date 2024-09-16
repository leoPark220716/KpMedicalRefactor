//
//  HospitalListCache.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import Foundation

class HospitalListCache{
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getCacheFileURL() -> URL {
        let timestamp = Date().timeIntervalSince1970
        return getDocumentsDirectory().appendingPathComponent("hospitalCache_\(timestamp).json")
    }
    //    캐시파일 저장
    func saveHospitalListToCache(_ newHospitals: [Hospitals]) {
        var allHospitals = loadHospitalListFromCache() ?? []
        allHospitals.append(contentsOf: newHospitals)
        
        let url = getCacheFileURL()
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(allHospitals)
                try data.write(to: url)
                print("Data successfully saved to cache.")
            } catch {
                print("Failed to save data to cache: \(error)")
            }
        }
    }


    //  캐시파일 병원 목록 로드
    func loadHospitalListFromCache() -> [Hospitals]? {
        let cacheDirectory = getDocumentsDirectory()
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            
            // 파일을 오름차순으로 정렬하여 가장 먼저 저장된 파일을 선택
            if let latestFile = files.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }).first {
                let data = try Data(contentsOf: latestFile)
                let hospitals = try JSONDecoder().decode([Hospitals].self, from: data)
                return hospitals
            }

        } catch {
            print("Failed to load data from cache: \(error)")
        }
        return nil
    }

    
    // 만료된 캐시파일 삭제
    func clearExpiredCacheFiles() {
        let fileManager = FileManager.default
        let cacheDirectory = getDocumentsDirectory()
        let expirationInterval: TimeInterval = 12 * 60 * 60 // 24시간
        
        DispatchQueue.global(qos: .background).async {
            do {
                let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
                let now = Date().timeIntervalSince1970
                
                for file in files {
                    if let timestampString = file.lastPathComponent.split(separator: "_").last?.split(separator: ".").first,
                       let timestamp = TimeInterval(timestampString),
                       now - timestamp > expirationInterval {
                        try fileManager.removeItem(at: file)
                        print("Expired cache file removed: \(file.lastPathComponent)")
                    }
                }
            } catch {
                print("Failed to clear expired cache files: \(error)")
            }
        }
    }
}
