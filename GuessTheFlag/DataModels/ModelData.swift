//
//  ModelData.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 28/07/2021.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var countries: [Country] = load("countries.json")
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func getRandomCountry(from countries: [Country], excluding excludedList: [Country]? = nil) -> Country {
    var index = Int.random(in: 0..<countries.count)
    
    if let exclusionList = excludedList {
        var excludedFlags: [String] = []
        
        for excluded in exclusionList {
            excludedFlags.append(excluded.flag)
        }
        
        while exclusionList.contains(countries[index]) || excludedFlags.contains(where: countries[index].exclusions.contains) {
            index = Int.random(in: 0..<countries.count)
        }
    }
    
    return countries[index]
}
