//
//  CustomSidebarPatient.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI

struct CustomSidebarPatient: View {
    @Binding var selectedMenu: String
    
    private let menus = [
        ("Sesi Latihan", "square.grid.2x2.fill"),
        ("Evaluasi Gerakan", "figure.run")
    ]
    
    @EnvironmentObject var session: SessionManager
    
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
            
            Button(action: {
                session.logout()
            }) {
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Logout")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.red)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            
        }
        .padding(.vertical)
        .frame(minWidth: 250, maxWidth: 300, alignment: .topLeading)
        .ignoresSafeArea()
    }
}

#Preview {
    StatefulPreviewWrapper("Sesi Latihan") { selectedMenu in
        CustomSidebarPatient(selectedMenu: selectedMenu)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
