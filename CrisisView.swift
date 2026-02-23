import SwiftUI

struct CrisisView: View {
    @State private var pulse = false
    @State private var showContent = false

    // Coffee palette on white
    private let coffee      = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeBg    = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let amber       = Color(red: 0.75, green: 0.50, blue: 0.15)
    private let rustOrange  = Color(red: 0.85, green: 0.45, blue: 0.15)
    private let dangerRed   = Color(red: 0.75, green: 0.22, blue: 0.18)
    private let textDark    = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec     = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Circle()
                .fill(rustOrange.opacity(0.06))
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
                .fill(rustOrange.opacity(0.08))
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
        .shadow(color: rustOrange.opacity(0.2), radius: 16)
    }

    private var crisisText: some View {
        VStack(spacing: 14) {
            Text("Weeks later, orange spots appear…")
                .font(.title2.bold())
                .foregroundColor(rustOrange)
                .multilineTextAlignment(.center)

            Text("Coffee Leaf Rust — a fungal disease that can destroy an entire harvest and wipe out a family's income.")
                .font(.body)
                .foregroundColor(textDark)
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
                .fill(coffeeBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(rustOrange.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private var scanButton: some View {
        NavigationLink {
            ScannerSnapView()
        } label: {
            Label("Scan Leaf", systemImage: "camera.viewfinder")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(colors: [rustOrange, dangerRed],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: rustOrange.opacity(0.3), radius: 8, y: 4)
        }
    }
}
