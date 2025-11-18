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
    @State private var genderId = 1
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    @State private var isClicked: Bool = false
    
    @StateObject private var viewModel = LoginRegisterViewModel()
    @EnvironmentObject var session: SessionManager
    
    let jenisKelaminOptions = ["Laki - Laki", "Perempuan"]
    
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
                    
                    
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer()
                            
                            Text("Buat Akun")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Mulai langkah barumu hari ini\nBergabung dan jadilah bagian dari komunitas kami.")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .lineSpacing(3)
                            
                            HStack(alignment: .top, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Nama Lengkap")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    TextField("Masukkan nama lengkap", text: $namaLengkap)
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
                                    
                                    TextField("Masukkan nomor handphone", text: $nomorHandphone)
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
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Masukkan email", text: $email)
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .medium))
                                
                                HStack {
                                    if isPasswordVisible {
                                        TextField("Masukkan password", text: $password)
                                    } else {
                                        SecureField("Masukkan password", text: $password)
                                    }
                                    
                                    Button(action: { isPasswordVisible.toggle() }) {
                                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Konfirmasi Password")
                                    .font(.system(size: 14, weight: .medium))
                                
                                HStack {
                                    if isConfirmPasswordVisible {
                                        TextField("Masukkan lagi password", text: $konfirmasiPassword)
                                    } else {
                                        SecureField("Masukkan lagi password", text: $konfirmasiPassword)
                                    }
                                    
                                    Button(action: { isConfirmPasswordVisible.toggle() }) {
                                        Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            
                            
                            HStack(alignment: .top, spacing: 16) {
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
                                
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pilih Jenis Kelamin")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Menu {
                                        ForEach(Array(jenisKelaminOptions.enumerated()), id: \.offset) { index, option in
                                            Button(action: {
                                                jenisKelamin = option
                                                genderId = index + 1
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
                            
                            
                            Button(action: {
                                Task {
                                    if (email != "" && namaLengkap != "" && password != "" && nomorHandphone != "" && DateHelper.convertDateToStr(date: tanggalLahir) != "" && genderId != 0) {
                                        try await viewModel.register(email: email, name: namaLengkap, password: password, phoneNumber: nomorHandphone, dateOfBirth: DateHelper.convertDateToStr(date: tanggalLahir), genderId: genderId)
                                    }
                                    
                                    if viewModel.errorMessage != nil {
                                        print(viewModel.errorMessage!)
                                    }
                                    
                                    self.isClicked = true
                                    
                                }
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
                            
                            if isClicked && ((email == "" || namaLengkap == "" || password == "" || nomorHandphone == "" || DateHelper.convertDateToStr(date: tanggalLahir) == "" || genderId == 0)) {
                                Text("Semua input harus terisi.")
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
                            
                            HStack(spacing: 4) {
                                Text("Sudah punya akun?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Button(action: {
                                }) {
                                    NavigationLink(destination: LoginPage()) {
                                        Text("Masuk sekarang!")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .underline()
                                    }
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

#Preview {
    RegisterPage()
}
