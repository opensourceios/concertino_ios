//
//  Composers.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ComposersSearchResults: View {
    @EnvironmentObject var composersSearch: ComposerSearchString
    @State private var composers = [Composer]()
    @State private var loading = true
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    func loadData() {
        loading = true
        
        if self.composersSearch.searchstring.count > 3 {
            APIget(AppConstants.openOpusBackend+"/composer/list/search/\(self.composersSearch.searchstring).json") { results in
                let composersData: Composers = parseJSON(results)
                
                DispatchQueue.main.async {
                    if let compo = composersData.composers {
                        self.composers = compo
                    }
                    else {
                        self.composers = [Composer]()
                    }
                    
                    self.loading = false
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.composers = [Composer]()
                self.loading = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.composersSearch.searchstring != "" {
                
                if self.loading {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: loading)
                        .configure { $0.color = .white; $0.style = .large }
                        Spacer()
                    }
                    .padding(40)
                }
                else {
                    if self.composers.count > 0 {
                        Text("Composers".uppercased())
                        .foregroundColor(Color(hex: 0x717171))
                        .font(.custom("Nunito", size: 12))
                        .padding(EdgeInsets(top: 7, leading: 20, bottom: 0, trailing: 0))
                        List(self.composers, id: \.id) { composer in
                            NavigationLink(destination: ComposerDetail(composer: composer)) {
                                ComposerRow(composer: composer)
                            }
                        }
                    }
                    else {
                        HStack(alignment: .top) {
                            VStack {
                                Image("warning")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color(hex: 0xa7a6a6))
                                    .frame(height: 28)
                                    .padding(5)
                                Text((self.composersSearch.searchstring.count > 3 ? "No matches for: \(self.composersSearch.searchstring)" : "Search term too short"))
                                    .foregroundColor(Color(hex: 0xa7a6a6))
                                    .font(.custom("Barlow", size: 14))
                            }
                        }.padding(15)
                    }
                }
            }
            Spacer()
        }
        .onAppear(perform: loadData)
        .onReceive(composersSearch.objectWillChange, perform: loadData)
        .frame(maxWidth: .infinity)
    }
}

struct ComposersSearchResults_Previews: PreviewProvider {
    static var previews: some View {
        ComposersSearch()
    }
}