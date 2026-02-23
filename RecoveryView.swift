import SwiftUI

struct RecoveryView: View {
    @State private var showCheck = false
    @State private var showText = false

    // Coffee palette on white
    private let coffee      = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeBg    = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let leafGreen   = Color(red: 0.25, green: 0.55, blue: 0.25)
    private let mintGreen   = Color(red: 0.35, green: 0.70, blue: 0.45)
    private let textDark    = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec     = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Circle()
                .fill(leafGreen.opacity(0.05))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: -40)

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(leafGreen.opacity(0.08))
                        .frame(width: 130, height: 130)
                        .scaleEffect(showCheck ? 1.0 : 0.5)

                    Circle()
                        .stroke(mintGreen.opacity(0.25), lineWidth: 2)
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
                .shadow(color: leafGreen.opacity(0.2), radius: 16)

                VStack(spacing: 16) {
                    Text("Crisis Avoided")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(textDark)

                    Text("Early detection can protect a family's livelihood.")
                        .font(.body.weight(.medium))
                        .foregroundColor(textDark.opacity(0.85))
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
                        .fill(coffeeBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(leafGreen.opacity(0.12), lineWidth: 1)
                        )
                )
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)

                Spacer()

                HStack(spacing: 8) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text("Built for farmers, by Indigo")
                        .font(.caption)
                        .foregroundColor(textSec)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Recovery")
        .navigationBarTitleDisplayMode(.inline)
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
