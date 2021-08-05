//
//  WikipediaExtractor.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 28/07/2021.
//

import Foundation
import NaturalLanguage

func wikiURL(for country: String) -> URL? {
    var components = URLComponents()
    
    components.scheme = "https"
    components.host = "en.wikipedia.org"
    components.path = "/w/api.php"
    components.queryItems = [
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "action", value: "query"),
        URLQueryItem(name: "prop", value: "extracts"),
        URLQueryItem(name: "exintro", value: nil),
        URLQueryItem(name: "explaintext", value: nil),
        URLQueryItem(name: "exsentences", value: "2"),
        URLQueryItem(name: "redirects", value: "1"),
        URLQueryItem(name: "titles", value: country)
    ]
    
    return components.url
}

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let extract: String
    
    var url: URL {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "en.wikipedia.org"
        components.queryItems = [
            URLQueryItem(name: "curid", value: String(pageid))
        ]
        
        return components.url!
    }
}

func sanitizeWikiExtract(for string: String) -> String {
    let workingString = returnOneSentence(for: string)
    
    if !isBal(string: extractBrackets(for: workingString)) {
        return sanitizeString(for: string)
    }
    
    guard let firstIndex = workingString.firstIndex(of: "(") else { return workingString.count > 35 ? sanitizeString(for: workingString) : sanitizeString(for: string) }
    var firstRParens: Int = 0
    
    var j = 0
    for c in workingString {
        if c == ")" {
            firstRParens = j
        }
        
        j += 1
    }
    
    var stack: [Int] = []
    var i = 0
    var lastIndex = 0
    
    for c in workingString {
        if i > firstRParens && !stack.isEmpty {
            if c == "(" {
                stack.append(i)
            } else if c == ")" {
                stack.removeLast()
            }
        } else if i > firstRParens && stack.isEmpty {
            lastIndex = i
            break
        } else {
            if c == "(" {
                stack.append(i)
            } else if c == ")" {
                stack.removeLast()
            }
        }
        
        i += 1
    }
    
    let result = String(workingString[..<firstIndex]) + workingString.substring(from: lastIndex + 1)
    
    if result.count > 35 {
        return sanitizeString(for: result)
    } else {
        return workingString.count > 50 ? sanitizeString(for: workingString) : sanitizeString(for: string)
    }
}

extension String {
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
}

func returnOneSentence(for string: String) -> String {
    var results: [String] = []
    
    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = string
    
    tokenizer.enumerateTokens(in: string.startIndex..<string.endIndex) { range, _ in
        results.append(String(string[range]))
        return true
    }
    
    return results.first ?? string
}

let brackets: [Character: Character] = [
    "[":"]",
    "(":")",
    "{":"}"
]
var openBrackets: [Character] { return Array(brackets.keys) }
var closeBrackets: [Character] { return Array(brackets.values) }

func isBal(string: String) -> Bool {
    if string.count % 2 != 0 { return false }
    var stack: [Character] = []
    for character in string {
        if closeBrackets.contains(character) {
            if stack.isEmpty {
                return false
            } else {
                let indexOfLastCharacter = stack.endIndex - 1
                let lastCharacterOnStack = stack[indexOfLastCharacter]
                if character == brackets[lastCharacterOnStack] {
                    stack.removeLast()
                } else {
                    return false
                }
            }
        }
        if openBrackets.contains(character) {
            stack.append(character)
        }
    }
    
    return stack.isEmpty
}

func extractBrackets(for string: String) -> String {
    let brackets = ["(", ")", "[", "]", "{", "}"]
    var result = ""
    
    for c in string {
        if brackets.contains(String(c)) {
            result += String(c)
        }
    }
    
    return result
}

func sanitizeString(for string: String) -> String {
    let purgeTerms = [
        "locally",
    ]
    
    var workingString: String = ""
    
    for term in purgeTerms {
        workingString = string.replacingOccurrences(of: term, with: "")
    }
    
    return workingString
        .replacingOccurrences(of: "(listen)", with: "")
        .replacingOccurrences(of: "( ", with: "(")
        .replacingOccurrences(of: " )", with: ")")
        .replacingOccurrences(of: " ,", with: ",")
        .replacingOccurrences(of: "()", with: "")
        .replacingOccurrences(of: " ;", with: ";")
        .replacingOccurrences(of: " ; ", with: "")
        .replacingOccurrences(of: "   ", with: " ")
        .replacingOccurrences(of: "  ", with: " ")
}
