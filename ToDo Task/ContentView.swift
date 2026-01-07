//
//  ContentView.swift
//  ToDo Task
//
//  Created SDGKU
//

import SwiftUI

struct ContentView: View {

    @State private var profiles: [Profile] = []
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("isDarkMode") private var isDarkMode = false
    let saveKey = "savedProfiles"
    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 40) {
                        
                        // 2. Header Section
                        VStack(spacing: 10) {
                            Text("Welcome Back")
                                .font(.subheadline)
                                .textCase(.uppercase)
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                            
                            Text("Who is working today?")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("whoisworking_text")
                        }

                        LazyVGrid(columns: columns, spacing: 25) {
                            ForEach($profiles) { $profile in
                                NavigationLink(value: profile) {
                                    ProfileCardView(profile: profile)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityIdentifier("profileCard_\(profile.name)")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .navigationDestination(for: Profile.self) { selectedProfile in
                if let index = profiles.firstIndex(where: {$0.id == selectedProfile.id}) {
                    DashboardView(profile: $profiles[index])
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                print("🟢 App is Active")
            } else if newValue == .inactive {
                print("🟡 App is Inactive")
            } else if newValue == .background {
                print("🔴 App is Background - Saving Data!")
                saveData()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    func saveData() {
        if let encodedData = try? JSONEncoder().encode(profiles){
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey){
            if let decodedProfiles = try? JSONDecoder().decode([Profile].self, from: savedData) {
                profiles = decodedProfiles
                return
            }
        }
        // show mock data for dev purposes
        profiles = Profile.sample
    }
}

// 4. Extracted Subview for cleaner code and better design
struct ProfileCardView: View {
    let profile: Profile
    
    var body: some View {
        VStack(spacing: 15) {
            Image(profile.profileImage)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                // Add a border ring to pop the image
                .overlay(Circle().stroke(Color.accentColor.opacity(0.3), lineWidth: 3))
                .shadow(radius: 5)
            
            Text(profile.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
