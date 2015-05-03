// Protocol Buffers for Swift
//
// Copyright 2014 Alexey Khohklov(AlexeyXo).
// Copyright 2008 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

protocol Message
{
    var unknownFields:UnknownFieldSet{get}
    func serializedSize() -> Int32
    func isInitialized() -> Bool
    func writeToCodedOutputStream(output:CodedOutputStream)
    func writeToOutputStream(output:NSOutputStream)
    func data()-> [Byte]
    func buider()-> MessageBuilder
    func toBuider()-> MessageBuilder
    var description:String {get}
}

protocol MessageBuilder
{
    func clear() -> Self
    var unknownFields:UnknownFieldSet{get}
    func isInitialized()-> Bool
    func mergeUnknownFields(unknownField:UnknownFieldSet) ->Self
    func mergeFromCodedInputStream(input:CodedInputStream) -> Self
    func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Self
    func mergeFromData(data:[Byte]) -> Self
    func mergeFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> Self
    func mergeFromInputStream(input:NSInputStream) -> Self
    func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> Self
}

func == (lhs: AbstractMessage, rhs: AbstractMessage) -> Bool
{
    return true;
}
class AbstractMessage:Equatable, Printable, Message {
    
    var unknownFields:UnknownFieldSet
    init()
    {
        unknownFields = UnknownFieldSet(fields: Dictionary())
    }
    
    var description:String {
        get {
            var output:String = ""
            writeDescriptionTo(&output, indent:"")
            return output
    
        }
    }
    func writeDescriptionTo(inout output:String, indent:String)
    {
        
    }
    
    func data() -> [Byte]
    {
        var size = serializedSize()
        let data:[Byte] = [Byte](count: Int(size), repeatedValue: 0)
        var stream:CodedOutputStream = CodedOutputStream(data: data)
        writeToCodedOutputStream(stream)
        return stream.buffer.buffer
    }
    func isInitialized() -> Bool
    {
        return false
    }
    func serializedSize() -> Int32
    {
        return 0
    }
    func writeToCodedOutputStream(output: CodedOutputStream)
    {
        println("failed")
    }
    func writeToOutputStream(output: NSOutputStream)
    {
        var codedOutput:CodedOutputStream = CodedOutputStream(output:output)
        writeToCodedOutputStream(codedOutput)
        codedOutput.flush()
    }
    
    //Same as above, but writes the size to the stream first
    func writeDelimitedToOutputStream(output: NSOutputStream)
    {
        var codedOutput:CodedOutputStream = CodedOutputStream(output:output)
        codedOutput.writeRawVarint32(self.serializedSize())
        writeToCodedOutputStream(codedOutput)
        codedOutput.flush()
    }

    
    func defaultInstance() -> Message
    {
        return AbstractMessage()
    }
    func buider() -> MessageBuilder
    {
        return AbstractMessageBuilder()
    }
    func toBuider() -> MessageBuilder
    {
        return AbstractMessageBuilder()
    }
    
    var hashValue: Int {
        get {
            return 0
        }
    }
    
}

extension AbstractMessage
{
    func getNSData() -> NSData
    {
        var nsdata:NSData = NSData(bytes: data(), length: data().count)
        return nsdata
    }
}

class AbstractMessageBuilder:MessageBuilder
{
    var unknownFields:UnknownFieldSet
    init()
    {
        unknownFields = UnknownFieldSet(fields:Dictionary())
    }
    
    
    
    func clone() -> Self
    {
        return self
    }
    func clear() -> Self
    {
        return self
    }
    
    func isInitialized() -> Bool
    {
        return false
    }
    
    func mergeFromCodedInputStream(input:CodedInputStream) -> Self
    {
        return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    
    func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Self
    {
        NSException(name:"ImproperSubclassing", reason:"", userInfo: nil).raise()
        return  self
    }

    
    func mergeUnknownFields(unknownField:UnknownFieldSet) -> Self
    {
        var merged:UnknownFieldSet = UnknownFieldSet.builderWithUnknownFields(unknownFields).mergeUnknownFields(unknownField).build()
        unknownFields = merged
        return self
    }
    
    func mergeFromData(data:[Byte]) -> Self
    {
        let input:CodedInputStream = CodedInputStream(data:data)
        mergeFromCodedInputStream(input)
        input.checkLastTagWas(0)
        return self
    }
    
    
    func mergeFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> Self
    {
        var input:CodedInputStream = CodedInputStream(data:data)
        mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
        input.checkLastTagWas(0)
        return self
    }
    
    func mergeFromInputStream(input:NSInputStream) -> Self
    {
        var codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        mergeFromCodedInputStream(codedInput)
        codedInput.checkLastTagWas(0)
        return self
    }
    func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> Self
    {
        var codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        mergeFromCodedInputStream(codedInput, extensionRegistry:extensionRegistry)
        codedInput.checkLastTagWas(0)
        return self
    }

}

