@0xbe97303b9e5b3429;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("vampipe::rpc");

using Vamp = import "vamp.capnp";

interface Piper {
    # RPC interface for use when using Cap'n Proto RPC layer.
    list               @0 (req :Vamp.ListRequest) -> (resp :Vamp.ListResponse);
    load               @1 (req :Vamp.LoadRequest) -> (resp :Vamp.LoadResponse);
    configure          @2 (req :Vamp.ConfigurationRequest) -> (resp :Vamp.ConfigurationResponse);
    process            @3 (req :Vamp.ProcessRequest) -> (resp :Vamp.ProcessResponse);
    finish             @4 (req :Vamp.FinishRequest) -> (resp :Vamp.FinishResponse);
}

