import SwiftUI

struct ContentView: View {
    @State private var animate = false

    // Coffee palette
    private let espresso    = Color(red: 0.16, green: 0.07, blue: 0.04)
    private let darkRoast   = Color(red: 0.24, green: 0.12, blue: 0.06)
    private let caramel     = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let cream       = Color(red: 0.96, green: 0.91, blue: 0.84)
    private let leafGreen   = Color(red: 0.30, green: 0.60, blue: 0.30)
    private let mintGreen   = Color(red: 0.40, green: 0.75, blue: 0.50)
    private let amber       = Color(red: 0.85, green: 0.55, blue: 0.20)
    private let textSec     = Color(red: 0.76, green: 0.66, blue: 0.54)
    private let lightRoast  = Color(red: 0.54, green: 0.35, blue: 0.18)

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [espresso, darkRoast],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                Circle()
                    .fill(caramel.opacity(0.06))
                    .frame(width: 500, height: 500)
                    .blur(radius: 100)
                    .offset(y: -100)

                VStack(spacing: 0) {
                    Spacer()
                    headerSection
                    Spacer()
                    hookSection.padding(.bottom, 32)
                    buttonsSection
                    Spacer().frame(height: 48)
                }
                .padding(.horizontal, 32)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(darkRoast)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle().stroke(caramel.opacity(0.3), lineWidth: 1.5)
                    )

                Image(systemName: "leaf.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(colors: [leafGreen, mintGreen],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            .scaleEffect(animate ? 1.0 : 0.8)
            .opacity(animate ? 1.0 : 0.0)
            .shadow(color: leafGreen.opacity(0.3), radius: 16)

            Text("Indigo")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundColor(cream)

            Text("Offline AI for Coffee Leaf Health")
                .font(.title3.weight(.medium))
                .foregroundColor(textSec)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                animate = true
            }
        }
    }

    // MARK: - Hook

    private var hookSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(amber)

            Text("A single disease can erase a year's income.")
                .font(.callout).italic()
                .foregroundColor(amber.opacity(0.9))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(amber.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(amber.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Buttons

    private var buttonsSection: some View {
        VStack(spacing: 14) {
            NavigationLink(destination: PlantingView()) {
                Label("Start Journey", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(LinearGradient(colors: [caramel, lightRoast],
                                              startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: caramel.opacity(0.4), radius: 8, y: 4)
            }

            NavigationLink(destination: ScannerSnapView()) {
                Label("Try Scanner", systemImage: "camera.viewfinder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(darkRoast.opacity(0.6))
                    .foregroundColor(cream)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(caramel.opacity(0.4), lineWidth: 1)
                    )
            }
        }
    }
}
