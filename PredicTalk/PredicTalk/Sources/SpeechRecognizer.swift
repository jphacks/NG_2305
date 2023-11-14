//
//  SpeechRecognizer.swift
//  PredicTalk
//
//  Created by 伊藤朝陽 on 2023/10/28.
//

import AVFoundation
import Speech
import SwiftUI

enum Language: CaseIterable, Identifiable {
    case italian
    case indonesian
    case ukrainian
    case dutch
    case spanish
    case thai
    case german
    case turkish
    case french
    case vietnamese
    case portuguese
    case russian
    case english_US
    case english_UK
    case korean
    case japanese
    
    var name: String {
        switch self {
        case .italian:
            return "イタリア語"
        case .indonesian:
            return "インドネシア語"
        case .ukrainian:
            return "ウクライナ語"
        case .dutch:
            return "オランダ語"
        case .spanish:
            return "スペイン語（スペイン）"
        case .thai:
            return "タイ語"
        case .german:
            return "ドイツ語"
        case .turkish:
            return "トルコ語"
        case .french:
            return "フランス語"
        case .vietnamese:
            return "ベトナム語"
        case .portuguese:
            return "ポルトガル語（ブラジル）"
        case .russian:
            return "ロシア語"
        case .english_US:
            return "英語（アメリカ）"
        case .english_UK:
            return "英語（イギリス）"
        case .korean:
            return "韓国"
        case .japanese:
            return "日本語"
        }
    }
    
    var locale: Locale {
        switch self {
        case .italian:
            return Locale.init(identifier: "it_IT")
        case .indonesian:
            return Locale.init(identifier: "id")
        case .ukrainian:
            return Locale.init(identifier: "uk")
        case .dutch:
            return Locale.init(identifier: "nl_NL")
        case .spanish:
            return Locale.init(identifier: "es_ES")
        case .thai:
            return Locale.init(identifier: "th")
        case .german:
            return Locale.init(identifier: "de_DE")
        case .turkish:
            return Locale.init(identifier: "tr")
        case .french:
            return Locale.init(identifier: "fr_FR")
        case .vietnamese:
            return Locale.init(identifier: "vi")
        case .portuguese:
            return Locale.init(identifier: "pt_BR")
        case .russian:
            return Locale.init(identifier: "ru")
        case .english_US:
            return Locale.init(identifier: "en_US")
        case .english_UK:
            return Locale.init(identifier: "en_GB")
        case .korean:
            return Locale.init(identifier: "ko")
        case .japanese:
            return Locale.init(identifier: "ja_JP")
        }
    }
    
    var id: Self {
        self
    }
}

class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable

        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }

    @Published var transcript: String = "Tap the screen to start transcripting."
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?

    init(language: Language) {
        initRecognizer(locale: language.locale)

        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
    }

    deinit {
        reset()
    }

    func initRecognizer(locale: Locale) {
        recognizer = SFSpeechRecognizer(locale: locale)
    }

    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }

    func transcribe() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.speakError(RecognizerError.recognizerIsUnavailable)
                return
            }

            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request

                self.task = recognizer.recognitionTask(with: request) { result, error in
                    let receivedFinalResult = result?.isFinal ?? false
                    let receivedError = error != nil

                    if receivedFinalResult || receivedError {
                        audioEngine.stop()
                        audioEngine.inputNode.removeTap(onBus: 0)
                    }

                    if let result = result {
                        self.speak(result.bestTranscription.formattedString)
                    }
                }
            } catch {
                self.reset()
                self.speakError(error)
            }
        }
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()

        return (audioEngine, request)
    }

    func stopTranscribing() {
        reset()
    }

    private func speak(_ message: String) {
        transcript = message
    }

    private func speakError(_ error: Error) {
            var errorMessage = ""
            if let error = error as? RecognizerError {
                errorMessage += error.message
            } else {
                errorMessage += error.localizedDescription
            }
            transcript = "<< \(errorMessage) >>"
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

