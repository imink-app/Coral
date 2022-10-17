//
//  LoginAuthPlugin.swift
//  Coral
//
//  Created by Jone Wang on 2022/10/17.
//

import Foundation
import InkMoya
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct LoginAuthPlugin: PluginType {
    let version: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let target = target as? AuthAPI {
            switch target {
            case .sessionToken,
                    .token,
                    .me:
                request.addValue("OnlineLounge/\(version) NASDKAPI iOS", forHTTPHeaderField: "User-Agent")
            case .login:
                request.addValue("com.nintendo.znca/\(version) (iOS/14.2)", forHTTPHeaderField: "User-Agent")
                request.addValue(version, forHTTPHeaderField: "X-ProductVersion")
            default:
                break
            }
        } else if let _ = target as? CoralAPI {
            request.addValue("com.nintendo.znca/\(version) (iOS/14.2)", forHTTPHeaderField: "User-Agent")
            request.addValue(version, forHTTPHeaderField: "X-ProductVersion")
        }
        
        return request
    }
}
