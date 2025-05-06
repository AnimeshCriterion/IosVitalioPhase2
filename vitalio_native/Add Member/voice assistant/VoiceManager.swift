//
//  VoiceManager.swift
//  vitalio_native
//
//  Created by HID-18 on 02/05/25.
//

import SwiftUI
import Starscream
import AVFoundation



class AudioCapture {
    private weak var socket: WebSocket?
    let audioEngine = AVAudioEngine()
    var audioConverter: AVAudioConverter?

    init(socket: WebSocket?) {
        self.socket = socket
    }

    func start() {
        guard let socket = socket else { return }
        socket.connect()
        
        let inputNode = audioEngine.inputNode
        let hwFormat = inputNode.inputFormat(forBus: 0)
        
        // Desired: 16kHz, mono, Float32
        let targetRate: Double = 16_000
        let targetFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: targetRate,
            channels: 1,
            interleaved: false
        )!
        
        audioConverter = AVAudioConverter(from: hwFormat, to: targetFormat)
        
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: hwFormat) { [weak self] inBuffer, _ in
            guard let self = self,
                  let converter = self.audioConverter else { return }
            
            // 1️⃣ How many input frames we got
            let inFrames = Int(inBuffer.frameLength)
            // 2️⃣ Compute how many output frames we should expect
            let ratio = targetRate / hwFormat.sampleRate
            let outFrames = AVAudioFrameCount(Double(inFrames) * ratio)
            
            // 3️⃣ Make an output buffer sized exactly for outFrames
            guard let outBuffer = AVAudioPCMBuffer(
                    pcmFormat: targetFormat,
                    frameCapacity: outFrames
                  ) else { return }
            
            // 4️⃣ Perform conversion
            let inputBlock: AVAudioConverterInputBlock = { _, status in
                status.pointee = .haveData
                return inBuffer
            }
            var error: NSError?
            let status = converter.convert(to: outBuffer,
                                           error: &error,
                                           withInputFrom: inputBlock)
            guard status == .haveData else {
                print("❌ Conversion failed: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            // 5️⃣ Convert Float32 → Int16 PCM LE
            guard let floatPtr = outBuffer.floatChannelData?[0] else { return }
            let framesWritten = Int(outBuffer.frameLength)
            var int16 = [Int16](repeating: 0, count: framesWritten)
            for i in 0..<framesWritten {
                let clamped = max(-1, min(floatPtr[i], 1))
                int16[i] = Int16(clamped * Float(Int16.max))
            }
            let data = int16.withUnsafeBufferPointer { Data(buffer: $0) }
            
            // 6️⃣ Sanity log & send
//            print("Swift → sending \(framesWritten) samples (\(data.count) bytes)")
            socket.write(data: data)
        }
        
        do {
            try audioEngine.start()
            print("🎤 Mic capture started (resampling to 16 kHz mono)…")
        } catch {
            print("❌ AudioEngine failed to start: \(error.localizedDescription)")
        }
    }





    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("🛑 Mic capture stopped.")
    }
    
    
}

