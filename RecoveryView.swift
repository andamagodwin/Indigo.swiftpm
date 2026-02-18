import SwiftUI

struct RecoveryView: View {
    @State private var showCheck = false
    @State private var showText = false

    // Coffee palette
    private let espresso    = Color(red: 0.16, green: 0.07, blue: 0.04)
    private let darkRoast   = Color(red: 0.24, green: 0.12, blue: 0.06)
    private let cream       = Color(red: 0.96, green: 0.91, blue: 0.84)
    private let leafGreen   = Color(red: 0.30, green: 0.60, blue: 0.30)
    private let mintGreen   = Color(red: 0.40, green: 0.75, blue: 0.50)
    private let textSec     = Color(red: 0.76, green: 0.66, blue: 0.54)
    private let textMuted   = Color(red: 0.56, green: 0.46, blue: 0.36)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.10, green: 0.14, blue: 0.06), espresso],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(leafGreen.opacity(0.08))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: -40)

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(leafGreen.opacity(0.12))
                        .frame(width: 130, height: 130)
                        .scaleEffect(showCheck ? 1.0 : 0.5)

                    Circle()
                        .stroke(mintGreen.opacity(0.3), lineWidth: 2)
                        .frame(width: 130, height: 130)
                        .scaleEffect(showCheck ? 1.0 : 0.5)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(
                            LinearGradient(colors: [leafGreen, mintGreen],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .scaleEffect(showCheck ? 1.0 : 0.3)
                        .opacity(showCheck ? 1.0 : 0.0)
                }
                .shadow(color: leafGreen.opacity(0.4), radius: 20)

                VStack(spacing: 16) {
                    Text("Crisis Avoided")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(cream)

                    Text("Early detection can protect a family's livelihood.")
                        .font(.body.weight(.medium))
                        .foregroundColor(cream.opacity(0.85))
                        .multilineTextAlignment(.center)

                    Text("With tools like Indigo, farmers can identify disease before it spreads — saving their harvest, their income, and their future.")
                        .font(.callout)
                        .foregroundColor(textSec)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(darkRoast.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(leafGreen.opacity(0.15), lineWidth: 1)
                        )
                )
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(leafGreen.opacity(0.5))
                    Text("Built for farmers, by Indigo")
                        .font(.caption)
                        .foregroundColor(textMuted)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Recovery")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                showCheck = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                showText = true
            }
        }
    }
}
