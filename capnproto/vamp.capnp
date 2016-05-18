
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

struct OutputDescriptor {
    basic              @0  :Basic;
    unit               @1  :Text;
    hasFixedBinCount   @2  :Bool        = false;
    binCount           @3  :Int32       = 0;
    binNames           @4  :List(Text)  = [];
    hasKnownExtents    @5  :Bool        = false;
    minValue           @6  :Float32     = 0.0;
    maxValue           @7  :Float32     = 0.0;
    isQuantized        @8  :Bool        = false;
    quantizeStep       @9  :Float32     = 0.0;
    sampleType         @10 :SampleType;
    sampleRate         @11 :Float32     = 0.0;
    hasDuration        @12 :Bool        = false;
}

struct PluginStaticData {
    pluginKey          @0  :Text;
    basic              @1  :Basic;
    maker              @2  :Text;
    copyright          @3  :Text;
    pluginVersion      @4  :Int32;
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
    values             @5  :List(Float32) = [];
}

struct FeatureSet {
    struct FSPair {
        output         @0  :Int32;
        features       @1  :List(Feature) = [];
    }
    featurePairs       @0  :List(FSPair);
}

struct PluginConfiguration {
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

struct LoadRequest {
    pluginKey          @0  :Text;
    inputSampleRate    @1  :Float32;
    adapterFlags       @2  :List(AdapterFlag);
}

struct LoadResponse {
    pluginHandle       @0  :Int32;
    staticData         @1  :PluginStaticData;
    defaultConfiguration @2  :PluginConfiguration;
}

struct ConfigurationRequest {
    pluginHandle       @0  :Int32;
    configuration      @1  :PluginConfiguration;
}

struct ConfigurationResponse {
    outputs            @0  :List(OutputDescriptor);
}

struct ProcessRequest {
    pluginHandle       @0  :Int32;
    input              @1  :ProcessInput;
}

struct VampRequest {
    request :union {
	list           @0  :Void;
	load           @1  :LoadRequest;
	configure      @2  :ConfigurationRequest;
	process        @3  :ProcessRequest;
	finish         @4  :Void;        # getRemainingFeatures and unload plugin
    }
}

struct VampResponse {
    success            @0  :Bool;
    errorText          @1  :Text = "";
    response :union {
	list           @2  :List(PluginStaticData);
	load           @3  :LoadResponse;
	configure      @4  :ConfigurationResponse;
	process        @5  :FeatureSet;
	finish         @6  :FeatureSet;
    }
}

