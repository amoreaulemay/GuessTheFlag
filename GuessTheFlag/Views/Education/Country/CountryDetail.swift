//
//  CountryDetail.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 28/07/2021.
//

import SwiftUI

struct CountryDetail: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var country: Country
    let resize: CGFloat = 150
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        ScrollView {
            MapView(country: country)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage(image: Image(country.flag), resize: resize)
                .padding(.bottom, -(resize / 2))
                .offset(y: -(resize / 2))
                
            VStack(alignment: .leading) {
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(country.name)
                            .font(.title)
                            .foregroundColor(.primary)
                        Text("Capital: \(country.capital)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Lat: \(country.coordinates.latitude, specifier: "%.4f")")
                        Text("Lng: \(country.coordinates.longitude, specifier: "%.4f")")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .padding([.leading, .trailing], 10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Quick Info")
                    .font(.title2)
                    .padding(.top, 10)
                
                if loadingState == .loading {
                    ProgressView()
                } else if loadingState == .loaded {
                    HStack {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(sanitizeWikiExtract(for: pages[0].extract))
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Spacer()
                        Link("Read More...", destination: pages[0].url)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Text("Network Error")
                }
                
                
            }
            .padding([.trailing, .leading], 10)
            
            .navigationTitle(country.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchDescription)
        }
    }
    
    func fetchDescription() {
        let urlString = wikiURL(for: country.name)
        
        guard let url = urlString else {
            print("Bad url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    self.pages = Array(items.query.pages.values)
                    self.loadingState = .loaded
                    return
                }
            }
            
            self.loadingState = .failed
            
        }.resume()
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var countries = ModelData().countries
    
    static var previews: some View {
        let id: Int = 0
        
        CountryDetail(country: countries[id])
    }
}
