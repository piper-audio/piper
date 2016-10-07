@0xbe97303b9e5b3429;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("piper::rpc");

using P = import "piper.capnp";

interface Piper {
    # RPC interface for use when using Cap'n Proto RPC layer.
    list               @0 (req :P.ListRequest) -> (resp :P.ListResponse);
    load               @1 (req :P.LoadRequest) -> (resp :P.LoadResponse);
    configure          @2 (req :P.ConfigurationRequest) -> (resp :P.ConfigurationResponse);
    process            @3 (req :P.ProcessRequest) -> (resp :P.ProcessResponse);
    finish             @4 (req :P.FinishRequest) -> (resp :P.FinishResponse);
}

