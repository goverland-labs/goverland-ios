//
//  SIWE_Message.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.08.23.
//

import Foundation

// https://eips.ethereum.org/EIPS/eip-4361

struct SIWE_Message {
    // OPTIONAL. The URI scheme of the origin of the request. Its value MUST be a RFC 3986 URI scheme.
    let scheme: String?

    // REQUIRED. The domain that is requesting the signing. Its value MUST be a RFC 3986 authority. The authority includes an OPTIONAL port. If the port is not specified, the default port for the provided scheme is assumed (e.g., 443 for HTTPS). If scheme is not specified, HTTPS is assumed by default.
    let domain: String

    // REQUIRED. The Ethereum address performing the signing. Its value SHOULD be conformant to mixed-case checksum address encoding specified in ERC-55 where applicable.
    let address: String

    // OPTIONAL. A human-readable ASCII assertion that the user will sign which MUST NOT include '\n' (the byte 0x0a).
    let statement: String?

    // REQUIRED. An RFC 3986 URI referring to the resource that is the subject of the signing (as in the subject of a claim).
    let uri: String

    // REQUIRED. The current version of the SIWE Message, which MUST be 1 for this specification.
    let version: String = "1"

    // REQUIRED. The EIP-155 Chain ID to which the session is bound, and the network where Contract Accounts MUST be resolved.
    let chainId: Int

    // REQUIRED. A random string typically chosen by the relying party and used to prevent replay attacks, at least 8 alphanumeric characters.
    let nonce: String

    // REQUIRED. The time when the message was generated, typically the current time. Its value MUST be an ISO 8601 datetime string.
    let issuedAt: String?

    // OPTIONAL. The time when the signed authentication message is no longer valid. Its value MUST be an ISO 8601 datetime string.
    let expirationTime: String?

    // OPTIONAL. The time when the signed authentication message will become valid. Its value MUST be an ISO 8601 datetime string.
    let notBefore: String?

    // OPTIONAL. An system-specific identifier that MAY be used to uniquely refer to the sign-in request.
    let requestId: String?


    // OPTIONAL. A list of information or references to information the user wishes to have resolved as part of authentication by the relying party. Every resource MUST be a RFC 3986 URI separated by "\n- " where \n is the byte 0x0a.
    let resources: [String]?


    // Form an EIP-4361 formated message for signature.
    func message() -> String {
        var message = ""

        if let scheme = scheme {
            message.append("\(scheme)://")
        }

        message.append("\(domain) wants you to sign in with your Ethereum account:")

        message.append("\n\(address)")

        if let statement = statement {
            message.append("\n\n\(statement)")
        }

        message.append("\n\nURI: \(uri)")

        message.append("\nVersion: \(version)")

        message.append("\nChain ID: \(chainId)")

        message.append("\nNonce: \(nonce)")

        if let issuedAt = issuedAt {
            message.append("\nIssued At: \(issuedAt)")
        }

        if let expirationTime = expirationTime {
            message.append("\nExpiration Time: \(expirationTime)")
        }

        if let notBefore = notBefore {
            message.append("\nNot Before: \(notBefore)")
        }

        if let requestId = requestId {
            message.append("\nRequest ID: \(requestId)")
        }

        if let resources = resources, !resources.isEmpty {
            message.append("\nResources:")
            resources.forEach {
                message.append("\n- \($0)")
            }
        }

        return message
    }
}

extension SIWE_Message {
    static func goverland(walletAddress: String) -> SIWE_Message {
        SIWE_Message(
            scheme: nil,
            domain: "goverland.xyz",
            address: walletAddress,
            statement: "Sign in",
            uri: "https://goverland.xyz/login",
            chainId: 1,
            nonce: String(Utils.randomNumber_8_dgts()),
            issuedAt: Date.now.ISO8601Format(),
            expirationTime: nil,
            notBefore: nil,
            requestId: nil,
            resources: nil)
    }

}
