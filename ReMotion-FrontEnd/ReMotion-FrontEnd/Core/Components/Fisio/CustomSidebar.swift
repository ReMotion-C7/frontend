//
//  CustomSidebar.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct CustomSidebar: View {
    @Binding var selectedMenu: String
    @State private var showLogoutAlert = false
    
    private let menus = [
        ("Pasien", "square.grid.2x2.fill"),
        ("Gerakan Latihan", "figure.run")
    ]
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // --- Header ---
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
            
            // --- Menu List ---
            ForEach(menus, id: \.0) { menu in
                Button(action: {
                    selectedMenu = menu.0
                }) {
                    HStack {
                        // ICON MENU
                        if selectedMenu == menu.0 {
                            // Jika dipilih: Putih
                            Image(systemName: menu.1)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: menu.1)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.clear)
                                .background(
                                    GradientPurple()
                                        .mask(
                                            Image(systemName: menu.1)
                                                .font(.system(size: 18, weight: .semibold))
                                        )
                                )
                        }
                        
                        Text("\(menu.0)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(selectedMenu == menu.0 ? .white : .black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        Group {
                            if selectedMenu == menu.0 {
                                GradientPurple()
                                    .cornerRadius(10)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.15))
                            }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                

                    Text("Fisioterapis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                
                Spacer()
                

                Button(action: {
                    showLogoutAlert = true
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(.clear)
                        .background(
                            GradientPurple()
                                .mask(
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 20))
                                )
                        )
                }
                .alert("Konfirmasi Logout", isPresented: $showLogoutAlert) {
                    Button("Batal", role: .cancel) { }
                    Button("Keluar", role: .destructive) {
                        session.logout()
                    }
                } message: {
                    Text("Apakah Anda yakin ingin keluar dari aplikasi?")
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

        }
        .padding(.vertical)
        .frame(minWidth: 250, maxWidth: 300, alignment: .topLeading)
        .ignoresSafeArea()
    }
}

//#Preview {
//    StatefulPreviewWrapper("Pasien") { selectedMenu in
//        CustomSidebar(selectedMenu: selectedMenu)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
