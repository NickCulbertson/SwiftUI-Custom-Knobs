import SwiftUI
import Controls

/// Knob in which you control the value by moving in a circular shape
public struct LogicKnob: View {
    @Binding var value: Float
    var text = ""
    
    var backgroundColor: Color = .gray
    var foregroundColor: Color = .red
    
    @State var isShowingValue = false
    var range: ClosedRange<Float>
    var origin: Float = 0
    
    /// Initialize the knob
    /// - Parameters:
    ///   - text: Default text that shows when the value is not shown
    ///   - value: Bound value that is being controlled
    ///   - range: Range of values
    ///   - origin: Center point from which to draw the arc, usually zero but can be 50% for pan
    public init(_ text: String, value: Binding<Float>,
                range: ClosedRange<Float> = 0 ... 127,
                origin: Float = 0) {
        _value = value
        self.origin = origin
        self.text = text
        self.range = range
    }
    
    func dim(_ proxy: GeometryProxy) -> CGFloat {
        min(proxy.size.width, proxy.size.height)
    }
    
    let minimumAngle = Angle(degrees: 35)
    let maximumAngle = Angle(degrees: 325)
    var angleRange: CGFloat {
        CGFloat(maximumAngle.degrees - minimumAngle.degrees)
    }
    
    var nondimValue: Float {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    var originLocation: Float {
        (origin - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    
    var trimFrom: CGFloat {
        if value >= origin {
            return minimumAngle.degrees / 360 + CGFloat(originLocation) * angleRange / 360.0
        } else {
            return (minimumAngle.degrees + CGFloat(nondimValue) * angleRange) / 360.0
        }
    }
    
    var trimLineStart: CGFloat {
        if value >= origin {
            return (minimumAngle.degrees +  CGFloat(nondimValue) * angleRange) / 360.0 + 0.0001 + 0.01
        } else {
            return (minimumAngle.degrees + CGFloat(originLocation) * angleRange) / 360.0 + 0.01
        }
    }
    
    var trimTo: CGFloat {
        if value >= origin {
            return (minimumAngle.degrees +  CGFloat(nondimValue) * angleRange) / 360.0 + 0.0001
        } else {
            return (minimumAngle.degrees + CGFloat(originLocation) * angleRange) / 360.0
        }
    }
    
    var normalizedValue: Double {
        Double((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    }
    
    public var body: some View {
        Control(value: $value, in: range,
                geometry: .twoDimensionalDrag(xSensitivity: 2, ySensitivity: 2),
                onStarted: { isShowingValue = true },
                onEnded: { isShowingValue = false }) { geo in
            VStack{
                Text("\(isShowingValue ? "\(Int(value))" : text)")
                    .frame(width: dim(geo) * 0.8)
                    .font(Font.system(size: dim(geo) * 0.2))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                ZStack(alignment: .center) {
                    ZStack(alignment: .center) {
                        Ellipse().fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.7, green: 0.7, blue: 0.7), Color(red: 0.5, green: 0.5, blue: 0.5)]), startPoint: .top, endPoint: .bottom)).shadow(radius: 15)
                        Ellipse().fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.5, green: 0.5, blue: 0.5)]), startPoint: .top, endPoint: .bottom)).padding(2).padding(.top,2)
                        Rectangle().foregroundColor(.white)
                            .frame(width: min(geo.size.width, geo.size.height) / 40, height: min(geo.size.width, geo.size.height) / 4)
                            .padding(.top,min(geo.size.width, geo.size.height)/1.34)
                            .rotationEffect(Angle(radians: normalizedValue * 1.6 * .pi + 0.2 * .pi))
                        
                    }.scaleEffect(x: 0.6, y: 0.6)
                    .drawingGroup()
                    Circle()
                        .trim(from: minimumAngle.degrees / 360.0, to: maximumAngle.degrees / 360.0)
                    
                        .rotation(.degrees(-270))
                        .stroke(.black.opacity(0.5),
                                style: StrokeStyle(lineWidth: dim(geo) / 16,
                                                   lineCap: .round))
                        .squareFrame(dim(geo) * 0.8)
                        .foregroundColor(foregroundColor)
                    
                    // Stroke value trim of knob
                    Circle()
                        .trim(from: trimFrom, to: trimTo)
                        .rotation(.degrees(-270))
                        .stroke(.orange,
                                style: StrokeStyle(lineWidth: dim(geo) / 20,
                                                   lineCap: .round))
                        .squareFrame(dim(geo) * 0.8)
                                            
                }.aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    .animation(.linear(duration: 0.15), value: value)

            }
        }
    }
}
