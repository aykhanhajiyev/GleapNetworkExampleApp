//
//  HTTPTask.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     additionHeaders: [HTTPHeader]?)
    
    case requestParametersAsArrayAndHeaders(bodyParameters: [Parameters]?,
                                            bodyEncoding: ParameterEncoding,
                                            urlParameters: Parameters?,
                                            additionHeaders: [HTTPHeader]?
    )
}
