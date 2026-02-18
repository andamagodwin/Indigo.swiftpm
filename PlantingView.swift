import SwiftUI

struct PlantingView: View {
    @State private var planted = false
    @State private var seedScale: CGFloat = 1.0

    // Coffee palette
    private let darkRoast   = Color(red: 0.24, green: 0.12, blue: 0.06)
    private let mediumRoast = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let caramel     = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let cream       = Color(red: 0.96, green: 0.91, blue: 0.84)
    private let leafGreen   = Color(red: 0.30, green: 0.60, blue: 0.30)
    private let mintGreen   = Color(red: 0.40, green: 0.75, blue: 0.50)
    private let textSec     = Color(red: 0.76, green: 0.66, blue: 0.54)

    var body: some View {
        ZStack {
            LinearGradient(colors: [mediumRoast, darkRoast],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Circle()
                .fill(leafGreen.opacity(planted ? 0.08 : 0.03))
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
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var storySection: some View {
        VStack(spacing: 14) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 32))
                .foregroundColor(caramel.opacity(0.6))

            Text("In the highlands of Uganda, a family depends on their coffee farm for everything — school fees, food, and hope.")
                .font(.body)
                .foregroundColor(cream.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Text(planted
                 ? "🌱 A tiny seedling breaks through the rich soil."
                 : "Tap the seed to plant your first coffee tree.")
                .font(.callout.weight(.medium))
                .foregroundColor(planted ? mintGreen : textSec)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(darkRoast.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(caramel.opacity(0.15), lineWidth: 1)
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
                        .foregroundColor(caramel.opacity(0.6))
                }
            }
        }
        .disabled(planted)
        .padding(.vertical, 16)
    }

    private var continueButton: some View {
        NavigationLink(destination: CrisisView()) {
            Label("Continue", systemImage: "arrow.right.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(LinearGradient(colors: [leafGreen, mintGreen],
                                          startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: leafGreen.opacity(0.4), radius: 8, y: 4)
        }
    }
}
