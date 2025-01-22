//
//  EventCreationView.swift
//  EventManager
//
//  Created by Shirin-Yan on 20.01.2025.
//

import SwiftUI
import PhotosUI

enum DateType {
    case none
    case start
    case end
}

struct EventCreationView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var vm: EventCreationVM
    
    @State private var selectedDate: Date = .now
    @State private var selectedDateType = DateType.none
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var resizingInProgress = false

    init() {
        let dbQueue = DatabaseManager.shared.getDBQueue()
        let useCase = CreateEventUseCase(eventRepo: EventRepoImpl(dbQueue: dbQueue))
        _vm = StateObject(wrappedValue: EventCreationVM(createEventUseCase: useCase))
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    mediaPicker()
                    textField(title: "Select Community", value: $vm.community)
                    textField(title: "Event Title", value: $vm.title)
                }.padding(20)
                    .background(Color.white)
                    .cornerRadius(10)
                
                VStack(spacing: 30) {
                    HStack {
                        Image(systemName: "chevron.up")
                            .padding(.trailing, 20)
                        Text("Starts")
                            .frame(width: 100, alignment: .leading)
                        
                        Button {
                            selectedDate = vm.startDate ?? Date()
                            selectedDateType = .start
                        } label: {
                            Text(vm.startDate == nil ? "Select Start Date" : vm.startDate!.toString())
                                .foregroundStyle(.black.opacity(vm.startDate == nil ? 0.2 : 1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                        }
                    }.font(.system(size: 16))
                    
                    HStack {
                        Image(systemName: "chevron.down")
                            .padding(.trailing, 20)
                        
                        Text("Ends")
                            .frame(width: 100, alignment: .leading)
                        Button {
                            selectedDate = vm.endDate ?? Date()
                            selectedDateType = .end
                        } label: {
                            Text((vm.endDate == nil ? "Select End Date" : vm.endDate!.toString()))
                                .foregroundStyle(.black.opacity(vm.endDate == nil ? 0.2 : 1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                        }
                    }.font(.system(size: 16))
                }.overlay(alignment: .leading) {
                    VLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .frame(width: 1, height: 50)
                        .padding(.horizontal, 8)
                }.padding(20)
                    .background(Color.white)
                    .cornerRadius(10)
                
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        Image(systemName: "pin")
                        textArea(title: "Event Location", value: $vm.location)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "pencil")
                        textArea(title: "Event Description", value: $vm.description)
                    }
                }.padding(20)
                    .background(Color.white)
                    .cornerRadius(10)
                
                Button {
                    if resizingInProgress {
                        vm.errorMessage = "Wait while media is resizing"
                        return
                    }
                    
                    if vm.saveEvent() {
                        coordinator.pop()
                    }
                } label: {
                    VStack {
                        Text("Create Event")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }.padding(.horizontal)
                    .padding(.vertical, 10)
            }.alert(isPresented: $vm.isAlertPresented) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }.scrollDismissesKeyboard(.immediately)
        }.background(Color.gray.opacity(0.1))
            .overlay(alignment: .center) {
                if selectedDateType != .none {
                    datePicker()
                }
            }.navigationTitle("Create Event")
    }
        
    @ViewBuilder func mediaPicker() -> some View {
        ZStack(alignment: .bottom) {
            if let thumbnail = vm.selectedMedia {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(4/5, contentMode: .fit)
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Color.black.opacity(0.2)
                    .aspectRatio(4/5, contentMode: .fit)
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .center)
                Image(systemName: "photo")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .imageScale(.large)
            }

            PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .videos]), photoLibrary: .shared()) {
                HStack {
                    Image(systemName: "photo")
                    Text(vm.selectedMedia == nil ? "Add Media" : "Replece Media")
                        .font(.system(size: 16, weight: .medium))
                }.padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
            }.onChange(of: selectedItem) { newItem in
                guard let newItem,
                      var contentType = newItem.supportedContentTypes.first,
                      let mimeType = contentType.preferredMIMEType  else {
                    vm.errorMessage = "Error reading media"
                    return
                }
                
                contentType = mimeType.contains("image") ? .image : .video
                resizingInProgress = true
                
                Task {
                    do {
                        guard let data = try await newItem.loadTransferable(type: Data.self) else { return }
                        await saveSelectedMedia(data: data, contentType: contentType)
                    } catch {
                        debugPrint(error)
                        resizingInProgress = false
                        vm.errorMessage = error.localizedDescription
                    }
                }
            }
            
            if resizingInProgress {
                ProgressView("Resizing...")
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.white.opacity(0.4))
            }
        }
    }
    
    @ViewBuilder func datePicker() -> some View {
        VStack(alignment: .trailing) {
            DatePicker("", selection: $selectedDate)
                .datePickerStyle(.graphical)
            
            Button("Save") {
                if selectedDateType == .start {
                    vm.startDate = selectedDate
                } else {
                    vm.endDate = selectedDate
                }
                
                selectedDateType = .none
            }.padding(.horizontal)
        }.padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedDateType = .none
                    }
            }
    }
    
    @ViewBuilder func textField(title: String, value: Binding<String>) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16))

            TextField(title, text: value)
                .padding(.horizontal, 20)
                .textFieldStyle(.plain)
                .font(.system(size: 16))
                .frame(height: 40)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
        }
    }
    
    @ViewBuilder func textArea(title: String, value: Binding<String>) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16))

            ZStack {
                if value.wrappedValue.isEmpty {
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 18)
                        .foregroundStyle(.black.opacity(0.2))
                }
                
                TextEditor(text: value)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 38)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
            }.font(.system(size: 16))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
        }
    }
    
    func saveSelectedMedia(data: Data, contentType: UTType) async {
        let resizedData: Data?
        let filename: String

        if contentType == .video {
            resizedData = await ResizeHelper.resizeVideo(data: data, toAspectRatio: 4/5)
            filename = UUID().uuidString + ".mp4"
        } else {
            resizedData = ResizeHelper.resizeImg(data: data, toAspectRatio: 4/5)
            filename = UUID().uuidString + ".jpg"
        }
        
        if let resizedData,
           FileManagerHelper.saveResizedMedia(data: resizedData, filename: filename) {
            DispatchQueue.main.async { [self] in
                vm.selectedFilename = filename
                vm.selectedMedia = contentType == .image ? UIImage(data: resizedData) : ThumbanilGenerator.shared.generateThumbnail(for: filename)
                resizingInProgress = false
            }
        } else {
            DispatchQueue.main.async { [self] in
                resizingInProgress = false
                vm.errorMessage = "Error resizing media"
            }
        }
    }
}

#Preview {
    EventCreationView()
}
