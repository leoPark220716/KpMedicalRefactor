//
//  ImageCache.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    func get(url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func set(url: URL, image: UIImage) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL
    private var cancellable: AnyCancellable?
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        if let cachedImage = ImageCache.shared.get(url: url) {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.image = image
                if let image = image {
                    ImageCache.shared.set(url: self.url, image: image)
                }
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
