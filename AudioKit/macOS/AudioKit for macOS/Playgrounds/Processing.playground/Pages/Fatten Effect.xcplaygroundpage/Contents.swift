//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Fatten Effect
//: ### This is a cool fattening effect that Matthew Flecher wanted for the
//: ### Analog Synth X project, so it was developed here in a playground first.
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: AKPlaygroundView.defaultSourceAudio,
                           baseDir: .Resources)


//: Here we set up a player to the loop the file's playback
let player = try AKAudioPlayer(file: file)
player.looping = true

let fatten = AKOperationEffect(player) { input, parameters in

    let time = parameters[0]
    let mix = parameters[1]

    let fatten = "\(input) dup \(1 - mix) * swap 0 \(time) 1.0 vdelay \(mix) * +"

    return AKStereoOperation(fatten)
}

AudioKit.output = fatten
AudioKit.start()

player.play()

fatten.parameters = [0.1, 0.5]

//: User Interface Set up

class PlaygroundView: AKPlaygroundView {

    override func setup() {
        addTitle("Analog Synth X Fatten")

        addButtons()

        addSubview(AKPropertySlider(
            property: "Time",
            format:  "%0.3f s",
            value: fatten.parameters[0],  minimum: 0.03, maximum: 0.1,
            color: AKColor.cyanColor()
        ) { sliderValue in
            fatten.parameters[0] = sliderValue
            })
        
        addSubview(AKPropertySlider(
            property: "Mix",
            value: fatten.parameters[1],
            color: AKColor.cyanColor()
        ) { sliderValue in
            fatten.parameters[1] = sliderValue
            })
    }

    override func startLoop(name: String) {
        player.stop()
        let file = try? AKAudioFile(readFileName: "\(name)", baseDir: .Resources)
        try? player.replaceFile(file!)
        player.play()
    }
    override func stop() {
        player.stop()
    }
}

let view = PlaygroundView(frame: CGRect(x: 0, y: 0, width: 500, height: 350))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = view

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)