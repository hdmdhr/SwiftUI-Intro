//
//  UserProfileView.swift
//  SwiftUI Intro
//
//  Created by Daniel Hu on 2021-12-13.
//

import SwiftUI

struct User: Codable {
    var userName: String
    var firstName: String
    var lastName: String
    var age: Int
}

struct UserProfileView: View {
    
    struct RowSpec: Identifiable {
        var id: Int { index }
        
        let index: Int
        let title: String
    }
    
    @State var user: User = .init(userName: "hdmdhr", firstName: "Daniel", lastName: "Hu", age: 29)
    
    let rowSpecs = ["Username", "First Name", "Last Name", "Age"]
        .enumerated()
        .map { (index, title) in
        RowSpec(index: index, title: title)
    }
    
    
    func getBindingFor(index: Int) -> Binding<String> {
        switch index {
        case 0: return $user.userName
        case 1: return $user.firstName
        case 2: return $user.lastName
        case 3: return .init(get: { String(user.age) }) { string in
            if let age = Int(string) {
                user.age = age
            }
        }
        default: return .constant("impossible index")
        }
    }
    
    var body: some View {
    
        List {
            Section {
                ForEach(rowSpecs) { rowSpec in
                    Row(rowSpec: rowSpec,
                        textBinding: getBindingFor(index: rowSpec.index))
                }
            } header: {
                Text("Basic Information")
            } footer: {
                FooterView()
            }

        }
        .listStyle(.plain)
        
    }
    
    
    
    struct Row: View {
        let rowSpec: RowSpec
        let textBinding: Binding<String>
        
        var body: some View {
            HStack {
                Text(rowSpec.title)
                    .frame(minWidth: 30, maxWidth: 100)
                
                TextField(rowSpec.title,
                          text: textBinding,
                          prompt: nil)
                    .padding([.leading, .vertical], 8)
            }
        }
    }

    
    struct FooterView: View {
        var body: some View {
            VStack {
                Button("Save Change") {
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(uiColor: .systemBrown), lineWidth: 3)
                )
                .padding([.horizontal, .top])
                
                Button("Change Password") {
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(uiColor: .systemBrown), lineWidth: 3)
                )
                .padding([.horizontal, .bottom])
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading)
            .background { Color(uiColor: .systemGreen) }
        }
    }

    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
