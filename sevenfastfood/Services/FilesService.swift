//
//  FilesService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 04/09/2023.
//

import Alamofire
final class FilesService {
    private var apiClient = APIClient.shared
    static let shared = FilesService()

    public func uploadAvatar(withImageData imageData: Data, uploadProgressHandler: @escaping (Progress) -> Void, completion: @escaping (Result<Response<File>?, Error>) -> Void) {
        apiClient.performUpload(withResponseType: Response<File>.self, withSubpath: "/files/upload/image/single?folder=avatar", withImageData: imageData, withImageName: "file", withParams: nil, uploadProgressHandler: uploadProgressHandler, completion: completion)
    }
}

