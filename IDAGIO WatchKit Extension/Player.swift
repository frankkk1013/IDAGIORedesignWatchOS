//
//  Player.swift
//  IDAGIO WatchKit Extension
//
//  Created by Francesco Iaccarino on 09/12/21.
//

import SwiftUI
import AVFAudio
import AVKit


let session = AVAudioSession.sharedInstance()
var player: AVAudioPlayer?
var outputVolumeObserve: NSKeyValueObservation?



struct Player: View {
    
    @State var playerPaused = true
    @State var title = "Etude Op. 10 No. 3 "
    @State var artist = "Chopin"
    
    @State var volumeFlag = false
    //used to blur or unblur the player when the volume interface shows up
    @State var voiceOverFlag = true
    //used to toggle the VoiceOver label when it shows the play or stop button
    
    
    var body: some View {
        
        
        VStack(alignment: .center){
            
            HStack{
                VStack(alignment: .leading){
                    Text(title).lineLimit(1)
                        .accessibilityLabel(title)
                    Text(artist).font(.footnote).foregroundColor(.gray).lineLimit(1)
                        .accessibilityLabel(artist)
                    
                }
                Spacer()
                
                //                    Image(systemName: "speaker.wave.2").font(.footnote).foregroundColor(.gray)
                //                        .accessibilityLabel("move the crown to change the volume level")
                
            }
            
            Spacer()
            
            HStack(spacing:40){
                //Spacer()
                Button(action: {
                    
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    
                }) {
                    Image( systemName: "backward.end")
                        .font(.title2)
                }.buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("backward")
                
                
                Button(action: {
                    
                    if(self.playerPaused){
                        WKInterfaceDevice.current().play(WKHapticType.start)
                        player?.play()
                        voiceOverFlag = false
                        
                    }else{
                        WKInterfaceDevice.current().play(WKHapticType.stop)
                        player?.stop()
                        
                    }
                    self.playerPaused.toggle()
                    
                }) {
                    Image(systemName: playerPaused ? "play.fill" : "pause.fill")
                        .font(.largeTitle)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 30, height: 30)
                .accessibilityLabel(playerPaused ? "play" : "pause")
                .accessibilityHint(voiceOverFlag ? "move the crown to change the volume level" : "")
                
                
                
                Button(action: {
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    
                }) {
                    Image( systemName: "forward.end")
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("froward")
                
                
            }.padding(17)
            
            Spacer()
            
            HStack(spacing: 70){
                Spacer()
                
                Button(action: {
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    // session.overrideOutputAudioPort(AVAudioSession.po)
                    activateRoute()
                    
                }) {
                    Image( systemName: "airplayaudio")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("airplay")
                
                
                Button(action: {
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    
                }) {
                    Image( systemName: "list.bullet").resizable().frame(width: 20, height: 13, alignment: .leading).foregroundColor(.gray)
                }.buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("tracklist")
                
                
                Spacer()
                
            }
            
            
        }
        .blur(radius: volumeFlag ? 10 : 0)
        .padding([.top, .leading, .trailing])
        //.ignoresSafeArea(.all, edges: .bottom)
        .navigationBarTitle(Text("Playing"))
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .background(VolumeView()
                    .frame(width: 40, height: 40)
                    .opacity(volumeFlag ? 100 : 0))
        .onAppear {
            setupAv()
            setupPlayer()
            activateRoute()
            voiceOverFlag = true
            
        }
        
    }
        
    func setupAv(){
        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longFormAudio,
                                    options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        
    }
    
    func setupPlayer(){
        // Set up the player.
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "etude", ofType: "mp3")!))
        } catch let error {
            print("*** Unable to set up the audio player: \(error.localizedDescription) ***")
            // Handle the error here.
            return
        }
                
    }
    
    func activateRoute(){
        // Activate and request the route.
        session.activate(options: []) { (success, error) in
            guard error == nil else {
                print("*** An error occurred: \(error!.localizedDescription) ***")
                // Handle the error here.
                return
            }
        }
        
        outputVolumeObserve = session.observe(\.outputVolume) { (av, changes) in
            
            volumeFlag = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                volumeFlag = false
            }
            
            
        }
        
        self.playerPaused = true
        
    }
    
}




struct VolumeView: WKInterfaceObjectRepresentable {
    
    typealias WKInterfaceObjectType = WKInterfaceVolumeControl
    
    func makeWKInterfaceObject(context: Self.Context) -> WKInterfaceVolumeControl {
        
        let view = WKInterfaceVolumeControl(origin: .local)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak view] timer in
            
            if let view = view {
                
                view.focus()
            } else {
                
                timer.invalidate()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            view.resignFocus()
            view.focus()
        }
        
        return view
    }
    
    
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceVolumeControl, context: WKInterfaceObjectRepresentableContext<VolumeView>) {
        
        
    }
    
}




struct Player_Previews: PreviewProvider {
    
    
    static var previews: some View {
        //Preview of different screen sizes
        Player().previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 41mm"))
        Player().previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 45mm"))
        Player().previewDevice(PreviewDevice(rawValue: "Apple Watch Series 5 - 40mm"))
        Player().previewDevice(PreviewDevice(rawValue: "Apple Watch Series 5 - 44mm"))
    }
}
