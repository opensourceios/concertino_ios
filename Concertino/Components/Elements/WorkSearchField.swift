//
//  OmnisearchField.swift
//  Concertino
//
//  Created by Adriano Brandao on 31/01/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkSearchField: View {
    @EnvironmentObject var AppState: AppState
    @Binding var workSearch: String
    @State private var searchString = ""
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    .frame(maxHeight: 15)
                
                ZStack(alignment: .leading) {
                    if self.searchString.isEmpty {
                        Text("Search for performers")
                            .foregroundColor(.black)
                            .font(.custom("Nunito", size: 15))
                            .padding(1)
                    }
                    TextField("", text: $searchString, onEditingChanged: { isEditing in
                            self.isEditing = isEditing
                        
                            if !isEditing && self.searchString.isEmpty {
                                self.searchString = self.workSearch
                            }
                        }, onCommit: {
                            self.workSearch = self.searchString
                        })
                        .keyboardType(.webSearch)
                        .textFieldStyle(SearchStyle())
                        .disableAutocorrection(true)
                }
                
                if !self.searchString.isEmpty {
                    Button(action: {
                        self.searchString = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color(hex: 0x7C726E))
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 5)
                    })
                }
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .foregroundColor(.black)
            .background(Color(.white))
            .cornerRadius(12)
            .clipped()
            
            if !self.workSearch.isEmpty || self.isEditing {
                Button(action: {
                        self.workSearch = ""
                        self.searchString = ""
                        self.endEditing(true)
                },
                       label: { Text("Cancel")
                        .foregroundColor(Color(hex: 0xfe365e))
                        .font(.custom("Nunito", size: 13))
                        .padding(4)
                })
            }
        }
    }
}

struct WorkSearchField_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
