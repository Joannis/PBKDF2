//
//  PBKDF2.swift
//  CryptoKitten
//
//  Created by Joannis Orlandos on 29/03/16.
//
//

import C7
import HMAC
import CryptoEssentials

public final class PBKDF2 {
    /// Used for applying an HMAC variant on a password and salt
    private static func digest(password: String, data: [Byte], variant: HashProtocol.Type) throws -> [Byte] {
        var passwordBytes = [Byte]()
        passwordBytes.append(contentsOf: password.utf8)
        
        return HMAC.authenticate(key: passwordBytes, message: data, variant: variant)
    }
    
    /// Applies the `hi` (PBKDF2 with HMAC as PseudoRandom Function)
    public static func calculate(password: String, salt: [Byte], iterations: Int, variant: HashProtocol.Type) throws -> [Byte] {
        var salt = salt
        salt.append(contentsOf:)(contentsOf: [0, 0, 0, 1])
        
        var ui = try digest(password, data: salt, variant: variant)
        var u1 = ui
        
        for _ in 0..<iterations - 1 {
            u1 = try digest(password, data: u1, variant: variant)
            ui = xor(ui, u1)
        }
        
        return ui
    }
}