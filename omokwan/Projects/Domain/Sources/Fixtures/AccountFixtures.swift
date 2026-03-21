//
//  AccountFixtures.swift
//  Domain
//
//  Created by 김동준 on 2/10/26
//

public enum AccountFixtures {
    public static let successResult = SignInResult(
        accessToken: "123123",
        signUpComplete: true
    )
    
    public static let needSignUpCompleteResult = SignInResult(
        accessToken: "123123",
        signUpComplete: false
    )
        
    public static let detailUserHost = DetailUserInfo(
        nickname: "테스트 닉네임",
        combo: 10000,
        stones: 1000,
        participantDays: 1,
        isHost: true
    )
}

public extension AccountFixtures {
    static let nicknameValid = NicknameDuplicateValidation(
        isValid: true,
        isDuplicated: false
    )
    
    static let nicknameDuplicatedAndValid = NicknameDuplicateValidation(
        isValid: true,
        isDuplicated: true
    )
    
    static let nicknameIsNotValid = NicknameDuplicateValidation(
        isValid: false,
        isDuplicated: false
    )
}
