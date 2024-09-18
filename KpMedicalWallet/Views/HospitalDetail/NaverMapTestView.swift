//
//  NaverMapTestView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/17/24.
//

import SwiftUI

import SwiftUI
import NMapsMap
struct NMFMapViewRepresentable: UIViewRepresentable {
    @Binding var coord: NMGLatLng
    let marker = NMFMarker()
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        print("makeUiView")
        marker.position = coord
        return mapView
    }
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        print("updateUiView")
        marker.position = coord
        marker.mapView = uiView
        DispatchQueue.main.async{
            let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
            uiView.moveCamera(cameraUpdate)
        }
    }
}

struct NaverMapTestView: View {
    @Binding var mapCoord: NMGLatLng
    var body: some View {
        VStack{
            NMFMapViewRepresentable(coord: $mapCoord)
            
        }
    }
}



