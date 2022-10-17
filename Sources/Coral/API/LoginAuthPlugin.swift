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
    let nsoVersion: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let target = target as? AuthAPI {
            switch target {
            case .sessionToken,
                    .token,
                    .me:
                request.addValue("OnlineLounge/\(nsoVersion) NASDKAPI iOS", forHTTPHeaderField: "User-Agent")
            case .login:
                request.addValue("com.nintendo.znca/\(nsoVersion) (iOS/14.2)", forHTTPHeaderField: "User-Agent")
                request.addValue(nsoVersion, forHTTPHeaderField: "X-ProductVersion")
            default:
                break
            }
        } else if let _ = target as? CoralAPI {
            request.addValue("com.nintendo.znca/\(nsoVersion) (iOS/14.2)", forHTTPHeaderField: "User-Agent")
            request.addValue(nsoVersion, forHTTPHeaderField: "X-ProductVersion")
        }
        
        return request
    }
}
