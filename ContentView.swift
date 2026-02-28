import SwiftUI

struct ContentView: View {
    @State private var animate = false

    // Coffee palette on white
    private let coffee = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeLight = Color(red: 0.54, green: 0.35, blue: 0.18)
    private let caramel = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let coffeeBg = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let amber = Color(red: 0.75, green: 0.50, blue: 0.15)
    private let leafGreen = Color(red: 0.25, green: 0.55, blue: 0.25)
    private let textDark = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                // Subtle warm tint at top
                Circle()
                    .fill(caramel.opacity(0.08))
                    .frame(width: 500, height: 500)
                    .blur(radius: 120)
                    .offset(y: -200)

                VStack(spacing: 0) {
                    Spacer()
                    headerSection
                    Spacer()
                    hookSection.padding(.bottom, 36)
                    buttonsSection
                    Spacer().frame(height: 48)
                }
                .padding(.horizontal, 32)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { route in
                switch route {
                case "Planting":
                    PlantingView()
                case "Scanner":
                    ScannerSnapView()
                case "Crisis":
                    CrisisView()
                case "Recovery":
                    RecoveryView()
                default:
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 132, height: 132)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: coffee.opacity(0.15), radius: 12, y: 4)
                .scaleEffect(animate ? 1.0 : 0.8)
                .opacity(animate ? 1.0 : 0.0)

            Text("Indigo")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(textDark)

            Text("Offline AI for Coffee Leaf Health")
                .font(.title3.weight(.medium))
                .foregroundColor(textSec)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    animate = true
                }
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
                .foregroundColor(amber)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(amber.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(amber.opacity(0.15), lineWidth: 1)
                )
        )
    }

    // MARK: - Buttons

    private var buttonsSection: some View {
        VStack(spacing: 14) {
            NavigationLink(value: "Planting") {
                Label("Start Journey", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [coffee, coffeeLight],
                            startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: coffee.opacity(0.3), radius: 8, y: 4)
            }

            NavigationLink(value: "Scanner") {
                Label("Try Scanner", systemImage: "camera.viewfinder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(coffeeBg)
                    .foregroundColor(coffee)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(coffee.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}
