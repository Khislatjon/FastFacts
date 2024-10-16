//
//  QuestionView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI
import AVFoundation

struct QuestionView: View, AudioPlayerProtocol {
    @Binding var question: String
    @State var questionPlaceholder = "Type your question or record..."
    @State var showAudioPlayerWave = false
    
    @State private var isRecording = false
    @State var recordedAudio: URL?
    @State private var audioRecorder: AVAudioRecorder!
    @State private var audioPlayer: AVAudioPlayer!
    @State private var recorderDelegate: RecorderDelegate?
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var audioRecorderEffect = false
    
    @State private var amplitude: CGFloat = 0.8
    @State private var phase: CGFloat = 0.0
    @State private var change: CGFloat = 0.1
    @State private var sheetHeight: CGFloat = .zero
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            addAddPhrase()
            
            Button {
                // Pass a question
                dismiss()
            } label: {
                Text("Ask")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding().padding(.horizontal)
                    .foregroundColor(Color.white)
                    .background(Color.appColor)
                    .cornerRadius(16)
            }
        }
        .padding()
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
    }
    
    @ViewBuilder
    func addAddPhrase() -> some View {
        VStack(spacing: 10) {
            Text("Add a Question")
                .font(.subheadline)
                .fontWeight(.semibold)
                .hSpacing(.leading)
                
            Text("Start recording your question and it will automatically convert to text")
                .font(.caption)
                .fontWeight(.regular)
                .hSpacing(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            ZStack(alignment: .center) {
                if self.isRecording {
                    self.addAudioRecordingWave()
                } else {
                    LinearGradient(gradient: Gradient(colors: [.white, Color.appColor, .white]), startPoint: .leading, endPoint: .trailing)
                        .frame(height: 1.0)
                }
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    .scaleEffect(audioRecorderEffect ? 2.0 : 1.0)
                    .animation(audioRecorderEffect ? Animation.easeInOut(duration: 0.5) : nil, value: audioRecorderEffect)
                
                Button {
                    if !self.isRecording {
                        self.audioRecorderEffect = true
                        self.startRecording()
                    } else {
                        self.stopRecording()
                        self.audioRecorderEffect = false
                    }
                } label: {
                    Image(systemName: self.isRecording ? "stop.fill" : "mic")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .frame(width: 70, height: 70)
                .background(Color.appColor)
                .clipShape(Circle())
                .shadow(color: Color.appColor, radius: 10)
            }
            .padding(.top, 10)
            
            TextField(self.questionPlaceholder, text: $question, axis: .vertical)
                .font(.caption)
                .lineLimit(8, reservesSpace: true)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.lightGray)
                )
        }
    }
    
    @ViewBuilder
    func addAudioRecordingWave() -> some View {
        MultiWave(amplitude: amplitude, color: Color.appColor, phase: phase)
            .frame(height: 80)
            .onAppear {
                withAnimation(Animation.linear(duration: 0.1)
                    .repeatForever(autoreverses: true)
                ) {
                    self.amplitude = _nextAmplitude()
                    self.phase -= 1.5
                }
            }
            .onAnimationCompleted(for: amplitude) {
                withAnimation(.linear(duration: 0.1)){
                    self.amplitude = _nextAmplitude()
                    self.phase -= 1.5
                }
            }
    }
    
    private func _nextAmplitude() -> CGFloat {
        // If the amplitude is too low or too high, cap it and go in the other direction.
        if self.amplitude <= 0.01 {
            self.change = 0.1
            return 0.02
        } else if self.amplitude > 0.9 {
            self.change = -0.1
            return 0.9
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        let newAmplitude = self.amplitude + (self.change * CGFloat.random(in: 0.3...0.8))
        return max(0.01, newAmplitude)
    }
}

extension QuestionView {
    
    func startRecording() {
        self.question = ""
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording_question.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            if self.audioRecorder == nil {
                self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                self.audioRecorder.prepareToRecord()
            }
            self.recorderDelegate = RecorderDelegate(parent: self)
            self.audioRecorder.delegate = recorderDelegate
            self.speechRecognizer.resetTranscript()
            self.speechRecognizer.startTranscribing()
            self.questionPlaceholder = "Transcribing..."
            self.audioRecorder.record()
            self.isRecording = true
        } catch {
            print("Error recording audio: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        self.speechRecognizer.stopTranscribing()
        self.audioRecorder.stop()
        self.setSessionPlayerOff()
        self.isRecording = false
        self.question = self.speechRecognizer.transcript
    }
    
    func createAudioPlayer() {
        self.setSessionPlayerOn()
        guard let recordedAudio = self.recordedAudio else { return }
        self.audioPlayer = try? AVAudioPlayer(contentsOf: recordedAudio)
        if self.audioPlayer != nil {
            self.audioPlayer.delegate = recorderDelegate
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setSessionPlayerOn() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        } catch let error {
            print("Error playAndRecord: \(error)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Error setActive: \(error)")
        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch let error {
            print("Error speaker: \(error)")
        }
    }
    
    func setSessionPlayerOff() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch _ {}
    }
    
    func requestPermissionToRecord() async {
        // Request permission to record.
        if await AVAudioApplication.requestRecordPermission() {
            // The user grants access. Present recording interface.
            print("Access Given")
            
            // Initialize AudioRecorder once access is given
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording_question.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder.prepareToRecord()
        } else {
            print("Access Not Given")
            // The user denies access. Present a message that indicates
            // that they can change their permission settings in the
            // Privacy & Security section of the Settings app.
        }
    }
}

#Preview {
    QuestionView(question: .constant("Question"))
}
