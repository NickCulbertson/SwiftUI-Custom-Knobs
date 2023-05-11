import SwiftUI
import Controls

struct ContentView: View {
    @State var value1 : Float = 0.0
    @State var value2 : Float = 0.0
    @State var value3 : Float = 0.0
    @State var value4 : Float = 0.0
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [.red.opacity(0.4), .purple.opacity(0.2)]), center: .top, startRadius: 100, endRadius: 1000).edgesIgnoringSafeArea(.all)
            VStack{
                HStack {
                    LogicKnob("Knob 1", value: $value1)
                    LogicKnob("Knob 2", value: $value2)
                }.padding()
                HStack {
                    LogicKnob("Knob 3", value: $value3)
                    LogicKnob("Knob 4", value: $value4)
                }.padding()
                Button("Reset Values") {
                    value1 = 0
                    value2 = 0
                    value3 = 0
                    value4 = 0
                }
            }
        }.background(Color(red: 0, green: 0, blue: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


