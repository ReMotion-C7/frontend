//
//  RegisterPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 23/10/25.
//

import SwiftUI

struct RegisterPage: View {
    @State private var namaLengkap = ""
    @State private var nomorHandphone = ""
    @State private var email = ""
    @State private var password = ""
    @State private var konfirmasiPassword = ""
    @State private var tanggalLahir = Date()
    @State private var jenisKelamin = "Laki - Laki"
    @State private var isPasswordVisible = false
    
    let jenisKelaminOptions = ["Laki - Laki", "Perempuan"]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left side - Gradient background with decorative circles
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.05, green: 0.15, blue: 0.2),
                            Color(red: 0.0, green: 0.05, blue: 0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Large green circle
                    Circle()
                        .fill(Color(red: 0.2, green: 0.8, blue: 0.5).opacity(0.3))
                        .frame(width: 500, height: 500)
                        .blur(radius: 50)
                        .offset(x: -100, y: 100)
                }
                .frame(width: geometry.size.width * 0.5)
                
                // Right side - Form
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer().frame(height: 30)
                        
                        Text("Buat Akun")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Mulai langkah barumu hari ini\nBergabung dan jadilah bagian dari komunitas kami.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .lineSpacing(3)
                        
                        // Nama Lengkap & Nomor Handphone
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nama Lengkap")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("John Doe", text: $namaLengkap)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nomor Handphone")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("08XXXXXXXX", text: $nomorHandphone)
                                    .keyboardType(.phonePad)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("example@email.com", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                } else {
                                    SecureField("", text: $password)
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
                                        password.isEmpty ? Color.gray.opacity(0.3) : Color(red: 0.2, green: 0.8, blue: 0.5),
                                        lineWidth: password.isEmpty ? 1 : 2
                                    )
                            )
                            .cornerRadius(8)
                        }
                        
                        // Konfirmasi Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Konfirmasi Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("", text: $konfirmasiPassword)
                                } else {
                                    SecureField("", text: $konfirmasiPassword)
                                }
                                
                                if !konfirmasiPassword.isEmpty && konfirmasiPassword == password {
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
                                        konfirmasiPassword.isEmpty ? Color.gray.opacity(0.3) : (konfirmasiPassword == password ? Color(red: 0.2, green: 0.8, blue: 0.5) : Color.red),
                                        lineWidth: konfirmasiPassword.isEmpty ? 1 : 2
                                    )
                            )
                            .cornerRadius(8)
                        }
                        
                        // Tanggal Lahir & Jenis Kelamin
                        HStack(alignment: .top, spacing: 16) {
                            // Tanggal Lahir
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tanggal Lahir")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                    
                                    DatePicker("", selection: $tanggalLahir, displayedComponents: .date)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 52)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Jenis Kelamin
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pilih Jenis Kelamin")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Menu {
                                    ForEach(jenisKelaminOptions, id: \.self) { option in
                                        Button(action: {
                                            jenisKelamin = option
                                        }) {
                                            Text(option)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Text(jenisKelamin)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 16))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 52)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Register Button
                        Button(action: {
                            // Action for register
                        }) {
                            Text("Daftar")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(8)
                        }
                        .padding(.top, 24)
                        
                        // Login link
                        HStack(spacing: 4) {
                            Text("Sudah punya akun?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Button(action: {
                                // Navigate to login
                            }) {
                                Text("Masuk sekarang!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .underline()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 60)
                }
                .frame(width: geometry.size.width * 0.5)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RegisterPage()
}
