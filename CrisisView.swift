import SwiftUI

struct CrisisView: View {
    @State private var pulse = false
    @State private var showContent = false

    // Coffee palette
    private let espresso    = Color(red: 0.16, green: 0.07, blue: 0.04)
    private let darkRoast   = Color(red: 0.24, green: 0.12, blue: 0.06)
    private let cream       = Color(red: 0.96, green: 0.91, blue: 0.84)
    private let amber       = Color(red: 0.85, green: 0.55, blue: 0.20)
    private let rustOrange  = Color(red: 0.85, green: 0.45, blue: 0.15)
    private let dangerRed   = Color(red: 0.80, green: 0.25, blue: 0.20)
    private let textSec     = Color(red: 0.76, green: 0.66, blue: 0.54)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.18, green: 0.08, blue: 0.04), espresso],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(rustOrange.opacity(0.08))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: -60)

            VStack(spacing: 28) {
                Spacer()
                warningSection
                crisisText
                scanButton
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 32)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }
        .navigationTitle("Crisis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { showContent = true }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var warningSection: some View {
        ZStack {
            Circle()
                .fill(rustOrange.opacity(0.15))
                .frame(width: 120, height: 120)
                .scaleEffect(pulse ? 1.15 : 0.9)

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(colors: [amber, rustOrange],
                                   startPoint: .top, endPoint: .bottom)
                )
                .scaleEffect(pulse ? 1.05 : 0.95)
        }
        .shadow(color: rustOrange.opacity(0.4), radius: 20)
    }

    private var crisisText: some View {
        VStack(spacing: 14) {
            Text("Weeks later, orange spots appear…")
                .font(.title2.bold())
                .foregroundColor(amber)
                .multilineTextAlignment(.center)

            Text("Coffee Leaf Rust — a fungal disease that can destroy an entire harvest and wipe out a family's income.")
                .font(.body)
                .foregroundColor(cream.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Text("But what if you could catch it early?")
                .font(.callout.weight(.medium))
                .italic()
                .foregroundColor(textSec)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(darkRoast.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(rustOrange.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var scanButton: some View {
        NavigationLink(destination: ScannerSnapView()) {
            Label("Scan Leaf", systemImage: "camera.viewfinder")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(LinearGradient(colors: [rustOrange, dangerRed],
                                          startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: rustOrange.opacity(0.4), radius: 8, y: 4)
        }
    }
}
