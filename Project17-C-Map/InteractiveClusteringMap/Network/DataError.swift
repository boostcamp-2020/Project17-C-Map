//
//  NetworkError.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/10.
//

import Foundation

enum NetworkError: Error {
    case url, author, param, unknown
    
    var localizedDescription: String {
        switch self {
        case .url:
            return "잘못된 주소 입니다."
        case .author:
            return "잘못된 인증키 입니다.."
        case .param:
            return "잘못된 파라미터 입니다."
        case .unknown:
            return "알 수 없는 에러입니다."
        }
    }
}

enum LocalError: Error {
    case notFoundFile
    
    var localizedDescription: String {
        switch self {
        case .notFoundFile:
            return "파일을 찾을 수 없습니다."
        }
    }
}
