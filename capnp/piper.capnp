
# Piper audio feature extraction: schema for low-level operation
#
# This file is formatted to 130 characters width, in order to fit the
# comments next to the schema definitions.
#
# Copyright (c) 2015-2017 Queen Mary, University of London, provided
# under a BSD-style licence. See the file COPYING for details.

@0xc4b1c6c44c999206;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("piper");

struct Basic {
    # Basic metadata common to many Piper structures.

    identifier         @0  :Text;                 # A computer-readable string. Must match the regex /^[a-zA-Z0-9_-]+$/.
    name               @1  :Text;                 # A short human-readable name or label. Must be present.
    description        @2  :Text;                 # An optional human-readable descriptive text that may accompany the name.
}

struct ParameterDescriptor {
    # Properties of an adjustable parameter. A parameter's value is just a single
    # float, but the descriptor explains how to interpret and present that value.
    # A Piper feature extractor has a static list of parameters. The properties of
    # a given parameter never change, in contrast to output descriptors, which
    # may have different properties depending on the configuration of the extractor.

    basic              @0  :Basic;                # Basic metadata about the parameter.
    unit               @1  :Text;                 # Human-recognisable unit of the parameter (e.g. Hz). May be left empty.
    minValue           @2  :Float32     = 0.0;    # Minimum value. Must be provided.
    maxValue           @3  :Float32     = 0.0;    # Maximum value. Must be provided.
    defaultValue       @4  :Float32     = 0.0;    # Default if the parameter is not set to anything else. Must be provided.
    isQuantized        @5  :Bool        = false;  # True if parameter values are quantized to a particular resolution.
    quantizeStep       @6  :Float32     = 0.0;    # Quantization resolution, if isQuantized.
    valueNames         @7  :List(Text)  = [];     # Optional human-readable labels for the values, if isQuantized.
}

enum SampleType {
    # How returned features are spaced on the input timeline.

    oneSamplePerStep   @0;                        # Each process input returns a feature aligned with that input's timestamp.
    fixedSampleRate    @1;                        # Features are equally spaced at a given sample rate.
    variableSampleRate @2;                        # Features have their own individual timestamps.
}

struct ConfiguredOutputDescriptor {
    # Properties of an output, that is, a single stream of features produced
    # in response to process and finish requests. A feature extractor may
    # have any number of outputs, and it always calculates and returns features
    # from all of them when processing; this is useful in cases where more
    # than one feature can be easily calculated using a single method.
    # This structure contains the properties of an output that are not static,
    # i.e. that may depend on the parameter values provided at configuration.

    unit               @0  :Text;                 # Human-recognisable unit of the bin values in output features. May be empty.
    hasFixedBinCount   @1  :Bool        = false;  # True if this output has an equal number of values in each returned feature.
    binCount           @2  :Int32       = 0;      # Number of values per feature for this output, if hasFixedBinCount.
    binNames           @3  :List(Text)  = [];     # Optional human-readable labels for the value bins, if hasFixedBinCount.
    hasKnownExtents    @4  :Bool        = false;  # True if all feature values fall within the same fixed min/max range.
    minValue           @5  :Float32     = 0.0;    # Minimum value in range for any value from this output, if hasKnownExtents.
    maxValue           @6  :Float32     = 0.0;    # Maximum value in range for any value from this output, if hasKnownExtents.
    isQuantized        @7  :Bool        = false;  # True if feature values are quantized to a particular resolution.
    quantizeStep       @8  :Float32     = 0.0;    # Quantization resolution, if isQuantized.
    sampleType         @9  :SampleType;           # How returned features from this output are spaced on the input timeline.
    sampleRate         @10 :Float32     = 0.0;    # Sample rate (features per second) if sampleType == fixedSampleRate.
    hasDuration        @11 :Bool        = false;  # True if features returned from this output will have a duration.
}

struct OutputDescriptor {
    # All the properties of an output, both static (the basic metadata) and
    # potentially dependent on configuration parameters (the configured descriptor).

    basic              @0  :Basic;                # Basic metadata about the output.
    configured         @1  :ConfiguredOutputDescriptor;    # Properties of the output that may depend on configuration parameters.
}

enum InputDomain {
    # Whether a feature extractor requires time-domain audio input (i.e.
    # "normal" or "unprocessed" audio samples) or frequency-domain input
    # (i.e. resulting from windowed, usually overlapping, short-time
    # Fourier transforms).

    timeDomain         @0;                        # The plugin requires time-domain audio samples as input.
    frequencyDomain    @1;                        # The plugin requires input to have been pre-processed using windowed STFTs.
}

struct ExtractorStaticData {
    # Static properties of a feature extractor. That is, metadata about the
    # extractor that are the same regardless of how you configure or run it.

    key                @0  :Text;                 # Composed string that identifies the extractor among all extractors (see docs).
    basic              @1  :Basic;                # Basic metadata about the extractor.
    maker              @2  :Text;                 # Human-readable text naming the author or vendor of the extractor.
    copyright          @3  :Text;                 # ??? review
    version            @4  :Int32;                # Version number of extractor; must increase if new algorithm changes outputs.
    category           @5  :List(Text);           # ??? review
    minChannelCount    @6  :Int32;                # Minimum number of input channels of audio this extractor can accept.
    maxChannelCount    @7  :Int32;                # Maximum number of input channels of audio this extractor can accept.
    parameters         @8  :List(ParameterDescriptor);    # List of configurable parameter properties for the feature extractor.
    programs           @9  :List(Text);           # List of predefined programs. For backward-compatibility, not recommended.
    inputDomain        @10 :InputDomain;          # Whether the extractor requires time-domain or frequency-domain input audio.
    basicOutputInfo    @11 :List(Basic);          # Basic metadata about all of the outputs of the extractor.
}

struct RealTime {
    # Time structure. When used as a timestamp, this is relative to "start
    # of audio".
    
    sec                @0  :Int32       = 0;      # Number of seconds.
    nsec               @1  :Int32       = 0;      # Number of nanoseconds. Must have same sign as sec unless sec == 0.
}

struct ProcessInput {
    # Audio and timing input data provided to a process request.

    inputBuffers       @0  :List(List(Float32));  # A single block of audio data (time or frequency domain) for each channel.
    timestamp          @1  :RealTime;             # Time of start of block (time-domain) or "centre" of it (frequency-domain).
}

struct Feature {
    # A single feature calculated and returned from a process or finish request.

    hasTimestamp       @0  :Bool        = false;  # True if feature has a timestamp. Must be true for a variableSampleRate output.
    timestamp          @1  :RealTime;             # Timestamp of feature, if hasTimestamp.
    hasDuration        @2  :Bool        = false;  # True if feature has a duration. Must be true if output's hasDuration is true.
    duration           @3  :RealTime;             # Duration of feature, if hasDuration.
    label              @4  :Text;                 # Optional human-readable text attached to feature.
    featureValues      @5  :List(Float32) = [];   # The feature values themselves (of size binCount, if output hasFixedBinCount).
}

struct FeatureSet {
    # The set of all features, across all outputs, calculated and returned from
    # a single process or finish request.

    struct FSPair {
        # A mapping between output identifier and ordered list of features for
	# that output.
	
        output         @0  :Text;                 # Output id, matching the output's descriptor's basic identifier.
        features       @1  :List(Feature) = [];   # Features calculated for that output during the current request, in time order.
    }
    
    featurePairs       @0  :List(FSPair);         # The feature lists for all outputs for which any features have been calculated.
}

struct Framing {
    # Determines how audio should be split up into frames (blocks, chunks,
    # buffers, etc) for input. If the feature extractor accepts frequency-domain
    # input, then this framing applies prior to the STFT transform.
    #
    # These values are sometimes mandatory, but in other contexts one or both may
    # be set to zero to mean "don't care". See documentation for structures that
    # include a framing field for details.
    
    blockSize          @0  :Int32;                # Number of time-domain audio samples per frame (on each channel).
    stepSize           @1  :Int32;                # Number of samples to advance between frames: equals blockSize for no overlap.
}

struct Configuration {
    # Bundle of parameter values and other configuration data for a feature-
    # extraction procedure.

    struct PVPair {
        # A mapping between parameter identifier and value.
	
        parameter      @0  :Text;                 # Parameter id, matching the parameter's descriptor's basic identifier.
        value          @1  :Float32;              # Value to set parameter to (within constraints given in parameter descriptor).
    }
    
    parameterValues    @0  :List(PVPair);         # Values for all parameters, or at least any that are to change from defaults.
    currentProgram     @1  :Text;                 # Selection of predefined program. For backward-compatibility, not recommended. 
    channelCount       @2  :Int32;                # Number of audio channels of input.
    framing            @3  :Framing;              # Step and block size for framing the input.
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

struct ListRequest {
    from               @0  :List(Text);
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
    framing            @2  :Framing;
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

struct FinishResponse {
    handle             @0  :Int32;
    features           @1  :FeatureSet;
}

struct Error {
    code               @0  :Int32;
    message            @1  :Text;
}

struct RpcRequest {
    # Request bundle for use when using Cap'n Proto serialisation without
    # Cap'n Proto RPC layer. For Cap'n Proto RPC, see piper.rpc.capnp.
    id :union {
        number         @0  :Int32;
        tag            @1  :Text;
        none           @2  :Void;
    }
    request :union {
	list           @3  :ListRequest;
	load           @4  :LoadRequest;
	configure      @5  :ConfigurationRequest;
	process        @6  :ProcessRequest;
	finish         @7  :FinishRequest;
        # finish gets any remaining calculated features and unloads
        # the feature extractor. Note that you can call finish at any
        # time -- even if you haven't configured or used the extractor,
        # it will unload any resources used and abandon the handle.
    }
}

struct RpcResponse {
    # Response bundle for use when using Cap'n Proto serialisation without
    # Cap'n Proto RPC layer. For Cap'n Proto RPC, see piper.rpc.capnp.
    id :union {
        number         @0  :Int32;
        tag            @1  :Text;
        none           @2  :Void;
    }
    response :union {
        error          @3  :Error;
	list           @4  :ListResponse;
	load           @5  :LoadResponse;
	configure      @6  :ConfigurationResponse;
	process        @7  :ProcessResponse;
	finish         @8  :FinishResponse;
    }
}

