import SwiftUI

struct PlantingView: View {
    @State private var planted = false
    @State private var seedScale: CGFloat = 1.0

    // Coffee palette on white
    private let coffee      = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeLight = Color(red: 0.54, green: 0.35, blue: 0.18)
    private let caramel     = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let coffeeBg    = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let leafGreen   = Color(red: 0.25, green: 0.55, blue: 0.25)
    private let mintGreen   = Color(red: 0.35, green: 0.70, blue: 0.45)
    private let textDark    = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec     = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Circle()
                .fill(leafGreen.opacity(planted ? 0.06 : 0.0))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: 50)
                .animation(.easeInOut(duration: 1.0), value: planted)

            VStack(spacing: 24) {
                Spacer()
                storySection
                seedSection
                if planted {
                    continueButton
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 32)
            .animation(.easeInOut(duration: 0.5), value: planted)
        }
        .navigationTitle("The Farm")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var storySection: some View {
        VStack(spacing: 14) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 32))
                .foregroundColor(caramel)

            Text("In the highlands of Uganda, a family depends on their coffee farm for everything — school fees, food, and hope.")
                .font(.body)
                .foregroundColor(textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Text(planted
                 ? "🌱 A tiny seedling breaks through the rich soil."
                 : "Tap the seed to plant your first coffee tree.")
                .font(.callout.weight(.medium))
                .foregroundColor(planted ? leafGreen : textSec)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(coffeeBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(caramel.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var seedSection: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                planted = true
                seedScale = 1.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { seedScale = 1.0 }
            }
        } label: {
            VStack(spacing: 8) {
                Text(planted ? "🌱" : "🫘")
                    .font(.system(size: 100))
                    .scaleEffect(seedScale)

                if !planted {
                    Text("TAP TO PLANT")
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundColor(coffee.opacity(0.5))
                }
            }
        }
        .disabled(planted)
        .padding(.vertical, 16)
    }

    private var continueButton: some View {
        NavigationLink {
            CrisisView()
        } label: {
            Label("Continue", systemImage: "arrow.right.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(colors: [leafGreen, mintGreen],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: leafGreen.opacity(0.3), radius: 8, y: 4)
        }
    }
}
