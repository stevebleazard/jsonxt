# jsonxt - JSON parsers for files, strings and more

*jsonxt* provides a number of JSON parsers and writers for various sources
and destinations including files and strings.  Features include

* RFC 8259 compliant when in strict and basic mode
* Performance focused especially for for files and strings
* Support for standard and extended JSON tree types:
  * Strict follows a strict interpretation of RFC 8259 with all
    numbers represented as floats.
  * Basic extendeds the strict type to include convience types while maintaining
    RFC compliance.  This is compatible with yojson's Basic type
  * Extended adds additional non-standard types including tuples and variants
    and is not RFC compliant. This is compatible with yojson's Safe type
* A number of different parsers including
  * A standard JSON tree parser
  * A Stream parser that returns a stream of raw JSON tokens.
  * A monad based parser compatible with async
* Writers including
  * File and string writers
  * A monad based writer that is compatible with async
  * A stream writer that converts a stream of JSON tokens
* Support for streaming JSON via Stream.t
* Standard interfaces including Yojson compatibility
