//
//  LoginPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 23/10/25.
//

import SwiftUI

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = true
    @State private var isPasswordVisible = false
    @State private var isClicked: Bool = false
    
    @EnvironmentObject var session: SessionManager
    @StateObject private var viewModel = LoginRegisterViewModel()
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ZStack {
                        Image("Background Login")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    }
                    .frame(width: geometry.size.width * 0.5)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        Text("Masuk")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Selamat datang kembali!\nLanjutkan perjalananmu dengan kami.")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email/Phone Number")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("Masukkan email kamu", text: $email)
                                .foregroundStyle(Color.black)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                        .padding(.top, 40)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("Masukkan password kamu", text: $password)
                                        .foregroundColor(Color.black)
                                } else {
                                    SecureField("Masukkan password kamu", text: $password)
                                        .foregroundColor(Color.black)
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Button(action: {
                                rememberMe.toggle()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                        .foregroundColor(rememberMe ? .black : .gray)
                                    Text("Ingat Saya")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Lupa password?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .underline()
                            }
                        }
                        .padding(.top, 16)
                        
                        Button(action: {
                            
                            Task {
                                if email != "" && password != "" {
                                    try await viewModel.login(identifier: email, password: password)
                                    
                                    if viewModel.errorMessage != nil {
                                        print(viewModel.errorMessage!)
                                    }
                                    
                                }
                                
                                self.isClicked = true
                                
                            }
                            
                        }) {
                            Text("Masuk")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(GradientPurple())
                                .cornerRadius(8)
                        }
                        .padding(.top, 24)
                        
                        if isClicked && (email.isEmpty || password.isEmpty) {
                            Text("Email dan password tidak boleh kosong.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        else if viewModel.errorMessage != nil {
                            Text(viewModel.errorMessage!)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        
                        // Register link
                        HStack(spacing: 4) {
                            Text("Belum punya akun?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            NavigationLink(destination: RegisterPage()) {
                                Text("Buat akun sekarang!")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                                    .underline()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 60)
                    .frame(width: geometry.size.width * 0.5)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                }
            }
            .onAppear {
                viewModel.session = session
            }
            .ignoresSafeArea()
        }
    }
    
}
