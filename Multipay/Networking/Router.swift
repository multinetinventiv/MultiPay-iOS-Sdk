//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkConstants {
  static let baseURLPath = "MY_BASE_URL_WILL_BE_HERE"
}

enum Router: URLRequestConvertible {
  
  
  case login
  case tags(String)
  case colors(String)
  
  var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .tags, .colors:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .login:
      return "/login"
    case .tags:
      return "/tags"
    case .colors:
      return "/colors"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .tags(let contentID):
      return ["image_upload_id": contentID]
    case .colors(let contentID):
      return ["image_upload_id": contentID, "extract_object_colors": 0]
    default:
      return [:]
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try NetworkConstants.baseURLPath.asURL()
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.timeoutInterval = TimeInterval(10*1000)
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
