//
//  CoralTokenPlugin.swift
//  Coral
//
//  Created by Jone Wang on 2022/10/17.
//

import Foundation
import InkMoya
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct CoralTokenPlugin: PluginType {
    let token: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
