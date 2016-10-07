@0xbe97303b9e5b3429;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("piper::rpc");

using P = import "piper.capnp";

interface Piper {
    # RPC interface for use when using Cap'n Proto RPC layer.
    list       @0 (listRequest :P.ListRequest) -> (listResponse :P.ListResponse);
    load       @1 (loadRequest :P.LoadRequest) -> (loadResponse :P.LoadResponse);
    configure  @2 (configurationRequest :P.ConfigurationRequest) -> (configurationResponse :P.ConfigurationResponse);
    process    @3 (processRequest :P.ProcessRequest) -> (processResponse :P.ProcessResponse);
    finish     @4 (finishRequest :P.FinishRequest) -> (finishResponse :P.FinishResponse);
}

