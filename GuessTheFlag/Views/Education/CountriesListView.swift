//
//  CountriesListView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 28/07/2021.
//

import SwiftUI

struct CountriesListView: View {
    @EnvironmentObject var modelData: ModelData
    
    var countries: [Country] {
        return modelData.countries
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< countries.count) { id in
                    NavigationLink(destination: CountryDetail(country: countries[id])) {
                        HStack {
                            Image(countries[id].flag)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(radius: 3)
                            VStack(alignment: .leading) {
                                Text(countries[id].name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                HStack(alignment: .bottom) {
                                    Text(countries[id].capital)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                    
                                    Text("Lat: \(countries[id].coordinates.latitude, specifier: "%.2f"), Lng: \(countries[id].coordinates.longitude, specifier: "%.2f")")
                                        .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Countries")
        }
    }
}

struct CountriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesListView()
            .environmentObject(ModelData())
    }
}
