//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/26/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        // 1
        let downloadTask = session.downloadTask(with: url,
                                                // 2
            completionHandler: { [weak self] url, response, error in
                if error == nil,
                    let url = url,
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.image = image
                        }
                    }
                }
        })
        // 5
        downloadTask.resume()
        return downloadTask
    }
}
