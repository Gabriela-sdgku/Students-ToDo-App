//
//  DashboardView.swift
//  ToDo Task
//
//  Created by Gabriela Sanchez on 04/02/26.
//


import SwiftUI

struct DashboardView: View {
    
    @State private var profiles: [Profile] = Profile.sample
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 40) {
                    VStack {
                        Text("Welcome to ToDo App")
                            .font(.subheadline)
                            .textCase(.uppercase)
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                            .accessibilityIdentifier("Welcome_text")
                        
                        Text("Who is working today?")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .accessibilityIdentifier("Welcome_text_subtitle")
                    }
                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach($profiles) { $profile in
                            NavigationLink(value: profile) {
                                ProfileCardView(profile: profile)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityIdentifier("ProfileCard_\(profile.name)")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Home")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                    .accessibilityIdentifier("DarkModeToggle")
                }
            }
            .navigationDestination(for: Profile.self) { selectedProfile in
                if let index = profiles.firstIndex(where: {$0.id == selectedProfile.id}){
                    ContentView(profile: $profiles[index])
                }
                
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ProfileCardView: View {
    let profile: Profile
    
    var body: some View {
        VStack(spacing: 15){
            ZStack {
                Image(profile.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .frame(width: 120, height: 120)
            Text(profile.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y:10)
        )
    }
}
