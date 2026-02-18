import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.05, blue: 0.15),
                             Color(red: 0.1, green: 0.12, blue: 0.3)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()
                    headerSection
                    Spacer()
                    buttonsSection
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 32)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 14) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(colors: [.green, .mint],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(color: .green.opacity(0.5), radius: 12)

            Text("Indigo")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Offline AI for Coffee Leaf Health")
                .font(.title3)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)

            Text("A single disease can erase a year's income.")
                .font(.callout)
                .italic()
                .foregroundColor(.orange.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
    }

    // MARK: - Buttons

    private var buttonsSection: some View {
        VStack(spacing: 16) {
            NavigationLink(destination: PlantingView()) {
                Label("Start Journey", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .green.opacity(0.4), radius: 8, y: 4)
            }

            NavigationLink(destination: ScannerSnapView()) {
                Label("Try Scanner", systemImage: "camera.viewfinder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
            }
        }
    }
}
