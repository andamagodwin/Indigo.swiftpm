import SwiftUI

struct CrisisView: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.08, blue: 0.02),
                         Color(red: 0.08, green: 0.06, blue: 0.14)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()
                warningSection
                crisisText
                scanButton
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Crisis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    // MARK: - Warning Icon

    private var warningSection: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 72))
            .foregroundColor(.orange)
            .scaleEffect(pulse ? 1.1 : 0.95)
            .shadow(color: .orange.opacity(0.5), radius: 12)
    }

    // MARK: - Text

    private var crisisText: some View {
        VStack(spacing: 12) {
            Text("Weeks later, orange spots appear…")
                .font(.title2.bold())
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)

            Text("Coffee Leaf Rust — a fungal disease that can destroy an entire harvest and wipe out a family's income.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Text("But what if you could catch it early?")
                .font(.callout)
                .italic()
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 4)
        }
    }

    // MARK: - Scan Button

    private var scanButton: some View {
        NavigationLink(destination: ScannerSnapView()) {
            Label("Scan Leaf", systemImage: "camera.viewfinder")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(colors: [.orange, .red],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: .orange.opacity(0.4), radius: 8, y: 4)
        }
    }
}
