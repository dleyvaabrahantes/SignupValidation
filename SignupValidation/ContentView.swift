//
//  ContentView.swift
//  SignupValidation
//
//  Created by David on 9/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var userName: String = ""
    @State private var isUsernameLengthValid: Bool = false
    @State private var isUsernameFormatValid: Bool = true
    
    @State private var passwordEntry : String = ""
    @State private var passwordReentry : String = ""
    @State private var showPassword: Bool = false
    @State private var passwordSecurityCheckProgress : Double = 0
    
    var body: some View {
        Form {
            Section{
                TextField("Username", text: $userName )
                    .onChange(of: userName) { newValue in
                        self.isUsernameLengthValid = newValue.count >= 5
                        self.isUsernameFormatValid = isValidString(newValue)
                    }
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Username")
            } footer: {
                VStack(alignment: .leading) {
                    Label("minimal of 5 characters", systemImage: isUsernameLengthValid ? "checkmark" : "xmark")
                        .foregroundColor(isUsernameLengthValid ? .green : .red)
                    Label("alphabets, numbers, or underscore", systemImage: isUsernameFormatValid ? "checkmark" : "xmark")
                        .foregroundColor(isUsernameFormatValid ? .green : .red)
                }
            }
            
            Section("Password") {
                HStack{
                    if showPassword {
                        TextField("Password", text: $passwordEntry)
                    }else {
                        SecureField("Password", text: $passwordEntry)
                    }
                    
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eye" : "eye.slash")
                    }

                }
                SecureField("Password (Verify)", text: $passwordReentry)
                if !passwordEntry.isEmpty,!passwordReentry.isEmpty, passwordEntry != passwordReentry {
                    Label("Password confirmation does not match", systemImage: "xmark.circle")
                        .foregroundColor(.red)
                }
                Gauge(value: passwordSecurityCheckProgress) {
                    Label("Password security", systemImage: passwordSecurityCheckProgress == 1.0 ? "checkmark" : "xmark")
                        .foregroundColor(passwordSecurityCheckProgress == 1.0 ? .green : .red)
                }
                
            }
            .onChange(of: passwordEntry) { newValue in
                withAnimation {
                    self.passwordSecurityCheckProgress = isSecurePassword(newValue)
                }
            }
        }
    }
    
    private func isSecurePassword(_ password: String) -> Double {
        
        var passwordStrenthScore: Double = 0
        
        let lowercaseLetterRegEx = ".*[a-z]+.*"
        let uppercaseLetterRegEx = ".*[A-Z]+.*"
        let digitRegEx = ".*[0-9]+.*"
        let specialCharacterRegEx = ".*[!©#$%^&*]+.*"
        let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegEx)
        let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegEx)
        let digitPredicate = NSPredicate (format: "SELF MATCHES %@", digitRegEx)
        let specialCharacterPredicate = NSPredicate (format: "SELF MATCHES %@", specialCharacterRegEx)
        
        if password.count >= 8 { passwordStrenthScore += 1 }
        if lowercaseLetterPredicate.evaluate (with: password){ passwordStrenthScore += 1 }
        if uppercaseLetterPredicate.evaluate (with: password){ passwordStrenthScore += 1 }
        if digitPredicate.evaluate (with: password){ passwordStrenthScore += 1 }
        if specialCharacterPredicate.evaluate (with: password){ passwordStrenthScore += 1 }
            
        return passwordStrenthScore / 5
        
    }
    
    private func isValidString(_ input: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        let inputCharacters = CharacterSet(charactersIn: input)
        
        return allowedCharacters.isSuperset(of: inputCharacters)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
