import SwiftUI

struct PlantingView: View {
    @State private var planted = false
    @State private var seedScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.12, blue: 0.05),
                         Color(red: 0.08, green: 0.08, blue: 0.18)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

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

    // MARK: - Story

    private var storySection: some View {
        VStack(spacing: 12) {
            Text("In the highlands of Uganda, a family depends on their coffee farm for everything — school fees, food, and hope.")
                .font(.body)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            Text(planted
                 ? "🌱 A tiny seedling breaks through the soil."
                 : "Tap the seed to plant your first coffee tree.")
                .font(.callout)
                .foregroundColor(planted ? .green : .white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Seed

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
            Text(planted ? "🌱" : "🫘")
                .font(.system(size: 100))
                .scaleEffect(seedScale)
        }
        .disabled(planted)
        .padding(.vertical, 20)
    }

    // MARK: - Continue

    private var continueButton: some View {
        NavigationLink(destination: CrisisView()) {
            Label("Continue", systemImage: "arrow.right.circle.fill")
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
    }
}
