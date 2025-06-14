import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentColor)
                
                Text("SportyPlanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
