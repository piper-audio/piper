
# Piper

## A protocol for driving audio feature extractors

Piper is a protocol for audio analysis and feature extraction. That
is, the task of processing sampled audio data to produce descriptive
output (measurements or semantic observations).

Piper defines a data schema and API that can be used for remote audio
feature extraction services, or for feature extractors loaded directly
into a host application.

Piper is intended to be used

 * as a programmatic interface for audio analysis and feature
   extraction methods for web applications and servers
 
 * to make [Vamp plugins](http://vamp-plugins.org), and feature
   extractors written in other languages such as Javascript, available
   through a service API or as loadable modules

The Piper schema is language- and serialisation-independent and the
API is transport-independent. We provide initial implementations using
JSON in Javascript and C++, and using Cap'n Proto in C++.

This repository contains the basic Piper schema. Implementations and
utilities can be found in neighbouring repositories.

## Authors and licensing

Piper was made by Lucas Thompson and Chris Cannam at the Centre for
Digital Music, Queen Mary, University of London.

Copyright (c) 2015-2017 Queen Mary, University of London, provided
under a BSD-style licence. See the file COPYING for details.

