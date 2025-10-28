//
//  CustomSidebar.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct CustomSidebar: View {
    @Binding var selectedMenu: String
    
    private let menus = [
        ("Pasien", "square.grid.2x2.fill"),
        ("Gerakan Latihan", "figure.run")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Remotion")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
                .fontWeight(.bold)
            
            ForEach(menus, id: \.0) { menu in
                Button(action: {
                    selectedMenu = menu.0
                }) {
                    HStack {
                        Image(systemName: menu.1)
                            .font(.system(size: 18, weight: .semibold))
                        Text("\(menu.0)")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(selectedMenu == menu.0 ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedMenu == menu.0 ? Color.black : Color.gray.opacity(0.15))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .frame(minWidth: 250, maxWidth: 300, alignment: .topLeading)
        .ignoresSafeArea()
    }
}

#Preview {
    StatefulPreviewWrapper("Pasien") { selectedMenu in
        CustomSidebar(selectedMenu: selectedMenu)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
