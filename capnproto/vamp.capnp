
@0xc4b1c6c44c999206;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("vampipe");

enum InputDomain {
    timeDomain         @0;
    frequencyDomain    @1;
}

enum SampleType {
    oneSamplePerStep   @0;
    fixedSampleRate    @1;
    variableSampleRate @2;
}

enum AdapterFlag {
    adaptInputDomain   @0;
    adaptChannelCount  @1;
    adaptBufferSize    @2;
}

const adaptAllSafe :List(AdapterFlag) =
      [ adaptInputDomain, adaptChannelCount ];

const adaptAll :List(AdapterFlag) =
      [ adaptInputDomain, adaptChannelCount, adaptBufferSize ];

struct RealTime {
    sec                @0  :Int32       = 0;
    nsec               @1  :Int32       = 0;
}

struct Basic {
    identifier         @0  :Text;
    name               @1  :Text;
    description        @2  :Text;
}

struct ParameterDescriptor {
    basic              @0  :Basic;
    unit               @1  :Text;
    minValue           @2  :Float32     = 0.0;
    maxValue           @3  :Float32     = 0.0;
    defaultValue       @4  :Float32     = 0.0;
    isQuantized        @5  :Bool        = false;
    quantizeStep       @6  :Float32     = 0.0;
    valueNames         @7  :List(Text)  = [];
}

struct ConfiguredOutputDescriptor {
    unit               @0  :Text;
    hasFixedBinCount   @1  :Bool        = false;
    binCount           @2  :Int32       = 0;
    binNames           @3  :List(Text)  = [];
    hasKnownExtents    @4  :Bool        = false;
    minValue           @5  :Float32     = 0.0;
    maxValue           @6  :Float32     = 0.0;
    isQuantized        @7  :Bool        = false;
    quantizeStep       @8  :Float32     = 0.0;
    sampleType         @9  :SampleType;
    sampleRate         @10 :Float32     = 0.0;
    hasDuration        @11 :Bool        = false;
}

struct OutputDescriptor {
    basic              @0  :Basic;
    configured         @1  :ConfiguredOutputDescriptor;
}

struct ExtractorStaticData {
    key                @0  :Text;
    basic              @1  :Basic;
    maker              @2  :Text;
    copyright          @3  :Text;
    version            @4  :Int32;
    category           @5  :List(Text);
    minChannelCount    @6  :Int32;
    maxChannelCount    @7  :Int32;
    parameters         @8  :List(ParameterDescriptor);
    programs           @9  :List(Text);
    inputDomain        @10 :InputDomain;
    basicOutputInfo    @11 :List(Basic);
}

struct ProcessInput {
    inputBuffers       @0  :List(List(Float32));
    timestamp          @1  :RealTime;
}

struct Feature {
    hasTimestamp       @0  :Bool        = false;
    timestamp          @1  :RealTime;
    hasDuration        @2  :Bool        = false;
    duration           @3  :RealTime;
    label              @4  :Text;
    featureValues      @5  :List(Float32) = [];
}

struct FeatureSet {
    struct FSPair {
        output         @0  :Text;
        features       @1  :List(Feature) = [];
    }
    featurePairs       @0  :List(FSPair);
}

struct Configuration {
    struct PVPair {
        parameter      @0  :Text;
        value          @1  :Float32;
    }
    parameterValues    @0  :List(PVPair);
    currentProgram     @1  :Text;
    channelCount       @2  :Int32;
    stepSize           @3  :Int32;
    blockSize          @4  :Int32;
}

struct ListRequest {
}

struct ListResponse {
    available          @0  :List(ExtractorStaticData);    
}

struct LoadRequest {
    key                @0  :Text;
    inputSampleRate    @1  :Float32;
    adapterFlags       @2  :List(AdapterFlag);
}

struct LoadResponse {
    handle             @0  :Int32;
    staticData         @1  :ExtractorStaticData;
    defaultConfiguration @2  :Configuration;
}

struct ConfigurationRequest {
    handle             @0  :Int32;
    configuration      @1  :Configuration;
}

struct ConfigurationResponse {
    handle             @0  :Int32;
    outputs            @1  :List(OutputDescriptor);
}

struct ProcessRequest {
    handle             @0  :Int32;
    processInput       @1  :ProcessInput;
}

struct ProcessResponse {
    handle             @0  :Int32;
    features           @1  :FeatureSet;
}

struct FinishRequest {
    handle             @0  :Int32;
}

struct Error {
    code               @0  :Int32;
    message            @1  :Text;
}

struct RpcRequest {
    request :union {
	list           @0  :ListRequest;
	load           @1  :LoadRequest;
	configure      @2  :ConfigurationRequest;
	process        @3  :ProcessRequest;
	finish         @4  :FinishRequest;     # getRemainingFeatures and unload
    }
}

struct RpcResponse {
    response :union {
        error          @0  :Error;
	list           @1  :ListResponse;
	load           @2  :LoadResponse;
	configure      @3  :ConfigurationResponse;
	process        @4  :ProcessResponse;
	finish         @5  :ProcessResponse;
    }
}

