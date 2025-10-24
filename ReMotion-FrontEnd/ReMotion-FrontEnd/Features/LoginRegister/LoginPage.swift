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
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.05, green: 0.15, blue: 0.2),
                            Color(red: 0.0, green: 0.05, blue: 0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                
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
                    
                    // Email/Phone field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email/Phone Number")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("example@email.com/08XXXXXX", text: $email)
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
                                TextField("", text: $password)
                            } else {
                                SecureField("", text: $password)
                                    .foregroundColor(Color.black)
                            }
                            
                            if !password.isEmpty {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.5))
                                    .padding(.trailing, 8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    password.isEmpty ? Color.white : Color(red: 0.2, green: 0.8, blue: 0.5),
                                    lineWidth: 2
                                )
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
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Forgot password?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .underline()
                        }
                    }
                    .padding(.top, 16)
                    
                    Button(action: {}) {
                        Text("Daftar")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(8)
                    }
                    .padding(.top, 24)
                    
                    // Register link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Button(action: {}) {
                            Text("Register now")
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
        .ignoresSafeArea()
    }
}

#Preview {
    LoginPage()
}
