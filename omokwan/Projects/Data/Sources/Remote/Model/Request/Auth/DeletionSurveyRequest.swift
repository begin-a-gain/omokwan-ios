//
//  DeletionSurveyRequest.swift
//  Data
//
//  Created by 김동준 on 12/24/25
//

struct DeletionSurveyRequest: Encodable {
    let reasons: [String]
    let otherReason: String?
    
    init(
        reasons: [String],
        otherReason: String? = nil
    ) {
        self.reasons = reasons
        self.otherReason = otherReason
    }
}
